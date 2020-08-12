const Sequelize = require('sequelize')

class LayoutVariable extends Sequelize.Model {
  static associate (models) {
    LayoutVariable.belongsTo(models.Layout)
    LayoutVariable.belongsTo(models.Variable)
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
      modelName: 'layoutVariable',
      paranoid: true,
      sequelize: sequelize
    })
  }
}

LayoutVariable.orderMap = {
  CREATED_AT: 'createdAt',
  UPDATED_AT: 'updatedAt'
}

module.exports = LayoutVariable
