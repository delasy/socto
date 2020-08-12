const Sequelize = require('sequelize')

class File extends Sequelize.Model {
  static associate (models) {
    File.belongsTo(models.Project)
    File.hasMany(models.FileVariable)
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
      folder: {
        allowNull: false,
        type: DataTypes.STRING
      },
      content: {
        allowNull: false,
        type: DataTypes.TEXT
      },
      cacheTTL: {
        allowNull: false,
        field: 'cache_ttl',
        type: DataTypes.INTEGER
      },
      mimeType: {
        allowNull: false,
        type: DataTypes.STRING
      }
    }, {
      hooks: {
        afterDestroy: (node) => {
          const { fileVariable: FileVariable } = File.sequelize.models

          return FileVariable.destroy({
            individualHooks: true,
            where: {
              fileId: node.id
            }
          })
        }
      },
      modelName: 'file',
      paranoid: true,
      sequelize: sequelize
    })
  }

  async checkUniqueName () {
    const { asset: Asset } = File.sequelize.models

    let node = await File.findOne({
      where: {
        projectId: this.projectId,
        name: this.name,
        folder: this.folder,
        id: {
          [Sequelize.Op.ne]: this.id
        }
      }
    })

    if (node !== null) {
      return false
    }

    node = await Asset.findOne({
      where: {
        projectId: this.projectId,
        name: this.name,
        folder: this.folder
      }
    })

    return node === null
  }

  async getAllVariables () {
    const { variable: Variable } = File.sequelize.models
    const project = await this.getProject()

    const fileVariables = await this.getFileVariables({
      include: [File, Variable]
    })

    const projectVariables = await project.getAllVariables()

    return [
      ...projectVariables,
      ...fileVariables,
      {
        value: this.folder,
        variable: {
          name: 'FILE_FOLDER'
        }
      },
      {
        value: this.name,
        variable: {
          name: 'FILE_NAME'
        }
      }
    ]
  }
}

File.orderMap = {
  NAME: 'name',
  FOLDER: 'folder',
  CREATED_AT: 'createdAt',
  UPDATED_AT: 'updatedAt'
}

module.exports = File
