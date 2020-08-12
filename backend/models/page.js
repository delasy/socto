const Sequelize = require('sequelize')

class Page extends Sequelize.Model {
  static associate (models) {
    Page.belongsTo(models.Layout)
    Page.belongsTo(models.Project)
    Page.hasMany(models.PageVariable)
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
      slug: {
        allowNull: false,
        type: DataTypes.STRING
      },
      folder: {
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
      },
      publishedAt: {
        allowNull: true,
        type: DataTypes.DATE
      }
    }, {
      hooks: {
        afterDestroy: (node) => {
          const { pageVariable: PageVariable } = Page.sequelize.models

          return PageVariable.destroy({
            individualHooks: true,
            where: {
              pageId: node.id
            }
          })
        }
      },
      modelName: 'page',
      paranoid: true,
      sequelize: sequelize
    })
  }

  async checkUniqueName () {
    const node = await Page.findOne({
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

  async checkUniqueSlug () {
    const node = await Page.findOne({
      where: {
        projectId: this.projectId,
        slug: this.slug,
        folder: this.folder,
        id: {
          [Sequelize.Op.ne]: this.id
        }
      }
    })

    return node === null
  }

  async getAllVariables () {
    const { variable: Variable } = Page.sequelize.models
    const layout = await this.getLayout()
    const project = await this.getProject()

    const pageVariables = await this.getPageVariables({
      include: [Page, Variable]
    })

    const layoutVariables = await layout.getAllVariables()
    const projectVariables = await project.getAllVariables()

    return [
      ...projectVariables,
      ...layoutVariables,
      ...pageVariables,
      {
        value: this.folder,
        variable: {
          name: 'PAGE_FOLDER'
        }
      },
      {
        value: this.name,
        variable: {
          name: 'PAGE_NAME'
        }
      },
      {
        value: this.slug,
        variable: {
          name: 'PAGE_SLUG'
        }
      }
    ]
  }
}

Page.orderMap = {
  NAME: 'name',
  SLUG: 'slug',
  FOLDER: 'folder',
  CREATED_AT: 'createdAt',
  PUBLISHED_AT: 'publishedAt',
  UPDATED_AT: 'updatedAt'
}

module.exports = Page
