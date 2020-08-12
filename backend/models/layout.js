const Sequelize = require('sequelize')

class Layout extends Sequelize.Model {
  static associate (models) {
    Layout.belongsTo(models.Project)
    Layout.hasMany(models.LayoutVariable)
    Layout.hasMany(models.Page)
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
      bodyCode: {
        allowNull: false,
        type: DataTypes.TEXT
      },
      headCode: {
        allowNull: false,
        type: DataTypes.TEXT
      },
      scripts: {
        allowNull: false,
        type: DataTypes.TEXT
      },
      styles: {
        allowNull: false,
        type: DataTypes.TEXT
      }
    }, {
      hooks: {
        afterDestroy: (node) => {
          const {
            layoutVariable: LayoutVariable,
            page: Page
          } = Layout.sequelize.models

          return Promise.all(
            [LayoutVariable, Page].map((Model) => {
              return Model.destroy({
                individualHooks: true,
                where: {
                  layoutId: node.id
                }
              })
            })
          )
        }
      },
      modelName: 'layout',
      paranoid: true,
      sequelize: sequelize
    })
  }

  async checkUniqueName () {
    const node = await Layout.findOne({
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

  async getAllVariables () {
    const { variable: Variable } = Layout.sequelize.models

    const layoutVariables = await this.getLayoutVariables({
      include: [Layout, Variable]
    })

    return [
      ...layoutVariables,
      {
        value: this.name,
        variable: {
          name: 'LAYOUT_NAME'
        }
      }
    ]
  }
}

Layout.orderMap = {
  NAME: 'name',
  CREATED_AT: 'createdAt',
  UPDATED_AT: 'updatedAt'
}

module.exports = Layout
