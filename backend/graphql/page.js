const validator = require('validator')
const _ = require('lodash')
const {
  UserInputError,
  ValidationError,
  gql
} = require('apollo-server-express')

const TemplateEngine = require('../template-engine')
const { Layout, Page, PageVariable, Project, Variable } = require('../models')
const { buildConnection } = require('./connection')
const { decodeIdAndCheck, encodeId } = require('./node')
const { processVariables } = require('./variable')

module.exports.typeDefs = gql`
  type Page implements Node {
    bodyCode: String!
    createdAt: DateTime!
    databaseId: UUID!
    folder: String!
    headCode: String!
    id: ID!
    layout: Layout!
    layoutId: ID!
    name: String!
    project: Project!
    projectId: ID!
    publishedAt: DateTime
    scripts: String!
    slug: String!
    styles: String!
    updatedAt: DateTime!
    variables (
      after: ID
      before: ID
      first: Int
      last: Int
      orderBy: PageVariableOrder = {
        direction: DESC
        field: CREATED_AT
      }
    ): Connection! @user
  }

  extend type Mutation {
    createPage (input: CreatePageInput!): Page! @user
    deletePage (id: ID!): Page! @user
    publishPage (id: ID!): Page! @user
    updatePage (id: ID!, input: UpdatePageInput!): Page! @user
  }

  extend type Query {
    pages (
      after: ID
      before: ID
      first: Int
      last: Int
      orderBy: PageOrder = {
        direction: DESC
        field: CREATED_AT
      }
      projectId: ID!
    ): Connection! @user
  }

  enum PageOrderField {
    NAME
    SLUG
    FOLDER
    CREATED_AT
    PUBLISHED_AT
    UPDATED_AT
  }

  input CreatePageInput {
    bodyCode: String!
    folder: String!
    headCode: String!
    layoutId: ID!
    name: String!
    projectId: ID!
    scripts: String!
    slug: String!
    styles: String!
    variables: [PageVariableInput!]!
  }

  input PageOrder {
    direction: OrderDirection!
    field: PageOrderField!
  }

  input UpdatePageInput {
    bodyCode: String!
    headCode: String!
    layoutId: ID!
    name: String!
    scripts: String!
    styles: String!
    variables: [PageVariableInput!]!
  }
`

const getNode = async (parent, args, ctx) => {
  const { id } = decodeIdAndCheck(args.id)

  const node = await Page.findOne({
    include: [Layout, Project],
    where: { id }
  })

  if (node === null) {
    throw new UserInputError('Invalid id', {
      invalidArgs: ['id']
    })
  } else if (node.project.userId !== ctx.user.id) {
    throw new UserInputError('Page is not owned by user', {
      invalidArgs: ['id']
    })
  }

  return node
}

const process = async (parent, args, ctx, info, action) => {
  const {
    bodyCode,
    folder,
    headCode,
    layoutId,
    name,
    slug,
    projectId,
    scripts,
    styles
  } = args.input

  let node
  let project

  if (action === 'create') {
    const { id } = decodeIdAndCheck(projectId, 'projectId')
    project = await Project.findByPk(id)

    if (project.userId !== ctx.user.id) {
      throw new UserInputError('Project is not owned by user', {
        invalidArgs: ['projectId']
      })
    }

    node = Page.build({
      projectId: project.id
    })
  } else {
    node = await getNode(parent, args, ctx, info)
    project = node.project
  }

  const { id: layoutIdDecoded } = decodeIdAndCheck(layoutId, 'layoutId')
  const layout = await Layout.findByPk(layoutIdDecoded)

  if (layout.projectId !== project.id) {
    throw new UserInputError('Layout is not owned by project', {
      invalidArgs: ['layoutId']
    })
  } else if (!validator.isLength(name, { min: 1, max: 255 })) {
    throw new UserInputError('Invalid name', {
      invalidArgs: ['name']
    })
  }

  node.layoutId = layout.id
  node.name = name.trim()

  const isNameUnique = await node.checkUniqueName()

  if (!isNameUnique) {
    throw new UserInputError('Name should be unique', {
      invalidArgs: ['name']
    })
  }

  if (action === 'create') {
    if (!validator.isLength(slug, { max: 255 })) {
      throw new UserInputError('Invalid slug', {
        invalidArgs: ['slug']
      })
    } else if (slug.includes('/')) {
      throw new UserInputError('Slug can\'t contain slahes', {
        invalidArgs: ['slug']
      })
    }
    if (folder !== '' && !folder.endsWith('/')) {
      throw new UserInputError('Folder should end with slash', {
        invalidArgs: ['folder']
      })
    }

    node.slug = slug.trim()
    node.folder = folder.trim()

    const isSlugUnique = await node.checkUniqueSlug()

    if (!isSlugUnique) {
      throw new UserInputError('Slug should be unique', {
        invalidArgs: ['slug']
      })
    }
  }

  node.headCode = headCode
  node.styles = styles
  node.bodyCode = bodyCode
  node.scripts = scripts

  await node.save()
  await processVariables(PageVariable, 'page', node, args)

  return node
}

module.exports.resolvers = {
  Mutation: {
    createPage: (parent, args, ctx, info) => {
      return process(parent, args, ctx, info, 'create')
    },
    deletePage: async (parent, args, ctx, info) => {
      const node = await getNode(parent, args, ctx, info)

      try {
        const oldpath = node.folder + node.slug
        const oldfullpath = oldpath === '' ? 'index' : oldpath

        await node.project.delete(oldfullpath)
      } catch {
        throw new ValidationError('Integration with providers failed')
      }

      return node.destroy()
    },
    publishPage: async (parent, args, ctx, info) => {
      const node = await getNode(parent, args, ctx, info)
      const variables = await node.getAllVariables()
      const vars = Variable.normalizeVars(variables)
      const path = node.folder + node.slug
      const fullpath = path === '' ? 'index' : path

      let content = '<!doctype html>' +
        '<html lang="en-us">' +
        '<head>' +
        node.project.globalHeadCode + node.layout.headCode + node.headCode +
        '<style>' +
        node.project.globalStyles + node.layout.styles + node.styles +
        '</style>' +
        '</head>' +
        '<body>' +
        node.project.globalBodyCode +
        '<script>(function (document, window) {' +
        node.project.globalScripts + node.layout.scripts + node.scripts +
        '})(document, window)</script>' +
        '</body>' +
        '</html>'

      content = content.replace(/{{ LAYOUT_CONTENT }}/g, node.layout.bodyCode)
      content = content.replace(/{{ PAGE_CONTENT }}/g, node.bodyCode)

      let processedContent = null

      try {
        processedContent = TemplateEngine.renderHTML(content, {
          ...vars,
          PAGE_URL: `{{ link('/${path}') }}`
        })
      } catch {
        throw new ValidationError('Failed to process')
      }

      try {
        await node.project.delete(fullpath)

        await node.project.put(fullpath, processedContent, {
          mimeType: 'text/html'
        })
      } catch {
        throw new ValidationError('Integration with providers failed')
      }

      node.publishedAt = new Date()
      return node.save()
    },
    updatePage: (parent, args, ctx, info) => {
      return process(parent, args, ctx, info, 'update')
    }
  },
  Page: {
    layout: (parent) => {
      return parent.getLayout()
    },
    layoutId: (parent) => {
      return encodeId(
        _.upperFirst(Layout.options.name.singular),
        parent.layoutId
      )
    },
    project: (parent) => {
      return parent.getProject()
    },
    projectId: (parent) => {
      return encodeId(
        _.upperFirst(Project.options.name.singular),
        parent.projectId
      )
    },
    variables: (parent, args) => {
      return buildConnection(PageVariable, parent, args)
    }
  },
  Query: {
    pages: async (parent, args, ctx) => {
      const { id } = decodeIdAndCheck(args.projectId, 'projectId')
      const project = await Project.findByPk(id)

      if (project.userId !== ctx.user.id) {
        throw new UserInputError('Project is not owned by user', {
          invalidArgs: ['projectId']
        })
      }

      return buildConnection(Page, project, args)
    }
  }
}
