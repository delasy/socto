const Sequelize = require('sequelize')

class ProjectVariable extends Sequelize.Model {
  static associate (models) {
    ProjectVariable.belongsTo(models.Project)
    ProjectVariable.belongsTo(models.Variable)
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
      modelName: 'projectVariable',
      paranoid: true,
      sequelize: sequelize
    })
  }
}

ProjectVariable.orderMap = {
  CREATED_AT: 'createdAt',
  UPDATED_AT: 'updatedAt'
}

module.exports = ProjectVariable
