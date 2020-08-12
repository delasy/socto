const Sequelize = require('sequelize')

class PageVariable extends Sequelize.Model {
  static associate (models) {
    PageVariable.belongsTo(models.Page)
    PageVariable.belongsTo(models.Variable)
  }

  static init (sequelize, DataTypes) {
    return super.init({
      id: {
        allowNull: false,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
        type: DataTypes.UUID
      },
      value: {
        allowNull: false,
        type: DataTypes.STRING
      }
    }, {
      modelName: 'pageVariable',
      paranoid: true,
      sequelize: sequelize
    })
  }
}

PageVariable.orderMap = {
  CREATED_AT: 'createdAt',
  UPDATED_AT: 'updatedAt'
}

module.exports = PageVariable
