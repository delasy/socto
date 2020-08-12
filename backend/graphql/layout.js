const validator = require('validator')
const _ = require('lodash')
const { UserInputError, gql } = require('apollo-server-express')

const { Layout, LayoutVariable, Project } = require('../models')
const { buildConnection } = require('./connection')
const { decodeIdAndCheck, encodeId } = require('./node')
const { processVariables } = require('./variable')

module.exports.typeDefs = gql`
  type Layout implements Node {
    bodyCode: String!
    createdAt: DateTime!
    databaseId: UUID!
    headCode: String!
    id: ID!
    name: String!
    project: Project!
    projectId: ID!
    scripts: String!
    styles: String!
    updatedAt: DateTime!
    variables (
      after: ID
      before: ID
      first: Int
      last: Int
      orderBy: LayoutVariableOrder = {
        direction: DESC
        field: CREATED_AT
      }
    ): Connection! @user
  }

  extend type Mutation {
    createLayout (input: CreateLayoutInput!): Layout! @user
    deleteLayout (id: ID!): Layout! @user
    updateLayout (id: ID!, input: UpdateLayoutInput!): Layout! @user
  }

  extend type Query {
    layouts (
      after: ID
      before: ID
      first: Int
      last: Int
      orderBy: LayoutOrder = {
        direction: DESC
        field: CREATED_AT
      }
      projectId: ID!
    ): Connection! @user
  }

  enum LayoutOrderField {
    NAME
    CREATED_AT
    UPDATED_AT
  }

  input CreateLayoutInput {
    bodyCode: String!
    headCode: String!
    name: String!
    projectId: ID!
    scripts: String!
    styles: String!
    variables: [LayoutVariableInput!]!
  }

  input LayoutOrder {
    direction: OrderDirection!
    field: LayoutOrderField!
  }

  input UpdateLayoutInput {
    bodyCode: String!
    headCode: String!
    name: String!
    scripts: String!
    styles: String!
    variables: [LayoutVariableInput!]!
  }
`

const getNode = async (parent, args, ctx) => {
  const { id } = decodeIdAndCheck(args.id)

  const node = await Layout.findOne({
    include: [Project],
    where: { id }
  })

  if (node === null) {
    throw new UserInputError('Invalid id', {
      invalidArgs: ['id']
    })
  } else if (node.project.userId !== ctx.user.id) {
    throw new UserInputError('Layout is not owned by user', {
      invalidArgs: ['id']
    })
  }

  return node
}

const process = async (parent, args, ctx, info, action) => {
  const { headCode, styles, bodyCode, scripts, name, projectId } = args.input
  let node

  if (action === 'create') {
    const { id } = decodeIdAndCheck(projectId, 'projectId')
    const project = await Project.findByPk(id)

    if (project.userId !== ctx.user.id) {
      throw new UserInputError('Project is not owned by user', {
        invalidArgs: ['projectId']
      })
    }

    node = Layout.build({
      projectId: project.id
    })
  } else {
    node = await getNode(parent, args, ctx, info)
  }

  if (!validator.isLength(name, { min: 1, max: 255 })) {
    throw new UserInputError('Invalid name', {
      invalidArgs: ['name']
    })
  }

  node.name = name.trim()

  const isNameUnique = await node.checkUniqueName()

  if (!isNameUnique) {
    throw new UserInputError('Name should be unique', {
      invalidArgs: ['name']
    })
  }

  node.headCode = headCode
  node.styles = styles

  if (!bodyCode.includes('{{ PAGE_CONTENT }}')) {
    throw new UserInputError(
      'Body code should contain PAGE_CONTENT variable',
      {
        invalidArgs: ['body_code']
      }
    )
  }

  node.bodyCode = bodyCode
  node.scripts = scripts

  await node.save()
  await processVariables(LayoutVariable, 'layout', node, args)

  return node
}

module.exports.resolvers = {
  Mutation: {
    createLayout: (parent, args, ctx, info) => {
      return process(parent, args, ctx, info, 'create')
    },
    deleteLayout: async (parent, args, ctx, info) => {
      const node = await getNode(parent, args, ctx, info)
      return node.destroy()
    },
    updateLayout: (parent, args, ctx, info) => {
      return process(parent, args, ctx, info, 'update')
    }
  },
  Layout: {
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
      return buildConnection(LayoutVariable, parent, args)
    }
  },
  Query: {
    layouts: async (parent, args, ctx) => {
      const { id } = decodeIdAndCheck(args.projectId, 'projectId')
      const project = await Project.findByPk(id)

      if (project.userId !== ctx.user.id) {
        throw new UserInputError('Project is not owned by user', {
          invalidArgs: ['projectId']
        })
      }

      return buildConnection(Layout, project, args)
    }
  }
}
