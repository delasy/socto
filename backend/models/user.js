const Sequelize = require('sequelize')

class User extends Sequelize.Model {
  static associate (models) {
    User.hasMany(models.Project)
  }

  static init (sequelize, DataTypes) {
    return super.init({
      id: {
        allowNull: false,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
        type: DataTypes.UUID
      },
      firstName: {
        allowNull: false,
        type: DataTypes.STRING
      },
      lastName: {
        allowNull: false,
        type: DataTypes.STRING
      },
      email: {
        allowNull: false,
        type: DataTypes.STRING
      },
      password: {
        allowNull: false,
        type: DataTypes.STRING
      }
    }, {
      hooks: {
        afterDestroy: (node) => {
          const { project: Project } = User.sequelize.models

          return Project.destroy({
            individualHooks: true,
            where: {
              userId: node.id
            }
          })
        }
      },
      modelName: 'user',
      paranoid: true,
      sequelize: sequelize
    })
  }

  static findOneByEmail (email) {
    return User.findOne({
      where: { email }
    })
  }
}

module.exports = User
