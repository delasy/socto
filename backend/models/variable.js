const Sequelize = require('sequelize')

class Variable extends Sequelize.Model {
  static associate (models) {
    Variable.belongsTo(models.Project)
    Variable.hasMany(models.FileVariable)
    Variable.hasMany(models.ProjectVariable)
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
      }
    }, {
      hooks: {
        afterDestroy: (node) => {
          const {
            fileVariable: FileVariable,
            projectVariable: ProjectVariable
          } = Variable.sequelize.models

          return Promise.all(
            [FileVariable, ProjectVariable].map((Model) => {
              return Model.destroy({
                individualHooks: true,
                where: {
                  variableId: node.id
                }
              })
            })
          )
        }
      },
      modelName: 'variable',
      paranoid: true,
      sequelize: sequelize
    })
  }

  async checkUniqueName () {
    const node = await Variable.findOne({
      where: {
        projectId: this.projectId,
        name: this.name,
        id: {
          [Sequelize.Op.ne]: this.id
        }
      }
    })

    return node === null
  }

  static normalizeVars (variables) {
    const vars = {}

    for (const item of variables) {
      vars[item.variable.name] = item.value
    }

    return vars
  }
}

Variable.orderMap = {
  NAME: 'name',
  CREATED_AT: 'createdAt',
  UPDATED_AT: 'updatedAt'
}

module.exports = Variable
