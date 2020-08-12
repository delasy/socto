const AWS = require('aws-sdk')
const Cloudflare = require('cloudflare')
const Sequelize = require('sequelize')

const TemplateEngine = require('../template-engine')

class Project extends Sequelize.Model {
  static associate (models) {
    Project.belongsTo(models.User)
    Project.hasMany(models.Asset)
    Project.hasMany(models.File)
    Project.hasMany(models.Icon)
    Project.hasMany(models.Layout)
    Project.hasMany(models.Page)
    Project.hasMany(models.ProjectVariable)
    Project.hasMany(models.Variable)
  }

  static init (sequelize, DataTypes) {
    return super.init({
      id: {
        allowNull: false,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
        type: DataTypes.UUID
      },
      name: {
        allowNull: false,
        type: DataTypes.STRING
      },
      description: {
        allowNull: false,
        type: DataTypes.STRING
      },
      publicURL: {
        allowNull: false,
        field: 'public_url',
        type: DataTypes.STRING
      },
      bucketProvider: {
        allowNull: false,
        type: Sequelize.ENUM,
        values: ['AWS']
      },
      bucketConfigAWS: {
        allowNull: true,
        field: 'bucket_config_aws',
        type: Sequelize.JSONB
      },
      cdnProvider: {
        allowNull: true,
        type: Sequelize.ENUM,
        values: ['CLOUDFLARE']
      },
      cdnConfigCloudflare: {
        allowNull: true,
        type: Sequelize.JSONB
      },
      globalHeadCode: {
        allowNull: false,
        type: Sequelize.TEXT
      },
      globalBodyCode: {
        allowNull: false,
        type: Sequelize.TEXT
      },
      globalStyles: {
        allowNull: false,
        type: Sequelize.TEXT
      },
      globalScripts: {
        allowNull: false,
        type: Sequelize.TEXT
      }
    }, {
      hooks: {
        afterDestroy: (node) => {
          const {
            asset: Asset,
            file: File,
            icon: Icon,
            projectVariable: ProjectVariable,
            variable: Variable
          } = Project.sequelize.models

          return Promise.all(
            [Asset, File, Icon, ProjectVariable, Variable].map((Model) => {
              return Model.destroy({
                individualHooks: true,
                where: {
                  projectId: node.id
                }
              })
            })
          )
        }
      },
      modelName: 'project',
      paranoid: true,
      sequelize: sequelize
    })
  }

  async checkUniqueName () {
    const node = await Project.findOne({
      where: {
        userId: this.userId,
        name: this.name,
        id: {
          [Sequelize.Op.ne]: this.id
        }
      }
    })

    return node === null
  }

  async copy (prevkey, key, opts = {}) {
    switch (this.bucketProvider) {
      case 'AWS': {
        const { bucketName, s3 } = this.getBucketConfigAWS()

        await s3.copyObject({
          ACL: 'public-read',
          Bucket: bucketName,
          CacheControl: TemplateEngine.getCacheTTL(opts.cacheTTL),
          ContentType: TemplateEngine.getMimeType(key, opts.mimeType),
          CopySource: '/' + bucketName + '/' + prevkey,
          Key: key,
          MetadataDirective: 'REPLACE'
        }).promise()

        break
      }
    }

    await this.purge(prevkey)
  }

  async delete (key) {
    switch (this.bucketProvider) {
      case 'AWS': {
        const { bucketName, s3 } = this.getBucketConfigAWS()

        await s3.deleteObject({
          Bucket: bucketName,
          Key: key
        }).promise()

        break
      }
    }

    await this.purge(key)
  }

  async getAllVariables () {
    const { variable: Variable } = Project.sequelize.models

    const projectVariables = await this.getProjectVariables({
      include: [Project, Variable]
    })

    const icons = await this.getIcons()
    const iconVariables = []

    for (const icon of icons) {
      iconVariables.push({
        value: icon.content,
        variable: {
          name: 'ICON_' + icon.variableName
        }
      })
    }

    return [
      ...iconVariables,
      ...projectVariables,
      {
        value: this.description,
        variable: {
          name: 'PROJECT_DESCRIPTION'
        }
      },
      {
        value: this.name,
        variable: {
          name: 'PROJECT_NAME'
        }
      },
      {
        value: this.publicURL,
        variable: {
          name: 'PUBLIC_URL'
        }
      },
      {
        value: Date.now(),
        variable: {
          name: 'TIMESTAMP'
        }
      }
    ]
  }

  getBucketConfigAWS () {
    const { accessKeyId, bucketName, secretAccessKey } = this.bucketConfigAWS
    const credentials = new AWS.Credentials(accessKeyId, secretAccessKey)

    return {
      accessKeyId: accessKeyId,
      credentials: credentials,
      bucketName: bucketName,
      secretAccessKey: secretAccessKey,
      s3: new AWS.S3({ credentials })
    }
  }

  getCDNConfigCloudflare () {
    const { apiToken, zoneId } = this.cdnConfigCloudflare
    const cloudflare = new Cloudflare({ token: apiToken })

    return {
      apiToken,
      cloudflare,
      zoneId
    }
  }

  async purge (key) {
    switch (this.cdnProvider) {
      case 'CLOUDFLARE': {
        const { cloudflare, zoneId } = this.getCDNConfigCloudflare()

        await cloudflare.zones.purgeCache(zoneId, {
          files: [this.publicURL + '/' + key]
        })

        break
      }
    }
  }

  async put (key, content, opts = {}) {
    switch (this.bucketProvider) {
      case 'AWS': {
        const { bucketName, s3 } = this.getBucketConfigAWS()

        await s3.putObject({
          ACL: 'public-read',
          Body: content,
          Bucket: bucketName,
          CacheControl: TemplateEngine.getCacheTTL(opts.cacheTTL),
          ContentType: TemplateEngine.getMimeType(key, opts.mimeType),
          Key: key
        }).promise()

        break
      }
    }

    await this.purge(key)
  }

  async upload (key, stream, opts = {}) {
    switch (this.bucketProvider) {
      case 'AWS': {
        const { bucketName, s3 } = this.getBucketConfigAWS()

        await s3.upload({
          ACL: 'public-read',
          Body: stream,
          Bucket: bucketName,
          CacheControl: TemplateEngine.getCacheTTL(opts.cacheTTL),
          ContentType: TemplateEngine.getMimeType(key, opts.mimeType),
          Key: key
        }).promise()

        break
      }
    }

    await this.purge(key)
  }
}

Project.orderMap = {
  NAME: 'name',
  DESCRIPTION: 'description',
  PUBLIC_URL: 'publicURL',
  CREATED_AT: 'createdAt',
  UPDATED_AT: 'updatedAt'
}

module.exports = Project
