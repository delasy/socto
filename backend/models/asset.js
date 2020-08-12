const Sequelize = require('sequelize')

class Asset extends Sequelize.Model {
  static associate (models) {
    Asset.belongsTo(models.Project)
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
      modelName: 'asset',
      paranoid: true,
      sequelize: sequelize
    })
  }

  async checkUniqueName () {
    const { file: File } = Asset.sequelize.models

    let node = await Asset.findOne({
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

    node = await File.findOne({
      where: {
        projectId: this.projectId,
        name: this.name,
        folder: this.folder
      }
    })

    return node === null
  }
}

Asset.orderMap = {
  NAME: 'name',
  FOLDER: 'folder',
  CREATED_AT: 'createdAt',
  UPDATED_AT: 'updatedAt'
}

module.exports = Asset
