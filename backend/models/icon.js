const Sequelize = require('sequelize')

class Icon extends Sequelize.Model {
  static associate (models) {
    Icon.belongsTo(models.Project)
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
      content: {
        allowNull: false,
        type: DataTypes.TEXT
      },
      variableName: {
        allowNull: false,
        type: DataTypes.STRING
      }
    }, {
      modelName: 'icon',
      paranoid: true,
      sequelize: sequelize
    })
  }

  async checkUniqueVariableName () {
    const node = await Icon.findOne({
      where: {
        projectId: this.projectId,
        variableName: this.variableName,
        id: {
          [Sequelize.Op.ne]: this.id
        }
      }
    })

    return node === null
  }
}

Icon.orderMap = {
  NAME: 'name',
  VARIABLE_NAME: 'variable_name',
  CREATED_AT: 'createdAt',
  UPDATED_AT: 'updatedAt'
}

module.exports = Icon
