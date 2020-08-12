const Sequelize = require('sequelize')

class FileVariable extends Sequelize.Model {
  static associate (models) {
    FileVariable.belongsTo(models.File)
    FileVariable.belongsTo(models.Variable)
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
      modelName: 'fileVariable',
      paranoid: true,
      sequelize: sequelize
    })
  }
}

FileVariable.orderMap = {
  CREATED_AT: 'createdAt',
  UPDATED_AT: 'updatedAt'
}

module.exports = FileVariable
