const validator = require('validator')
const _ = require('lodash')
const { UserInputError, gql } = require('apollo-server-express')

const { Icon, Project } = require('../models')
const { buildConnection } = require('./connection')
const { decodeIdAndCheck, encodeId } = require('./node')

module.exports.typeDefs = gql`
  type Icon implements Node {
    content: String!
    createdAt: DateTime!
    databaseId: UUID!
    id: ID!
    name: String!
    project: Project!
    projectId: ID!
    updatedAt: DateTime!
    variableName: String!
  }

  extend type Mutation {
    createIcon (input: CreateIconInput!): Icon! @user
    deleteIcon (id: ID!): Icon! @user
    updateIcon (id: ID!, input: UpdateIconInput!): Icon! @user
  }

  extend type Query {
    icons (
      after: ID
      before: ID
      first: Int
      last: Int
      orderBy: IconOrder = {
        direction: DESC
        field: CREATED_AT
      }
      projectId: ID!
    ): Connection! @user
  }

  enum IconOrderField {
    NAME
    VARIABLE_NAME
    CREATED_AT
    UPDATED_AT
  }

  input CreateIconInput {
    content: String!
    name: String!
    projectId: ID!
  }

  input IconOrder {
    direction: OrderDirection!
    field: IconOrderField!
  }

  input UpdateIconInput {
    content: String!
    name: String!
  }
`

const getNode = async (parent, args, ctx) => {
  const { id } = decodeIdAndCheck(args.id)

  const node = await Icon.findOne({
    include: [Project],
    where: { id }
  })

  if (node === null) {
    throw new UserInputError('Invalid id', {
      invalidArgs: ['id']
    })
  } else if (node.project.userId !== ctx.user.id) {
    throw new UserInputError('Icon is not owned by user', {
      invalidArgs: ['id']
    })
  }

  return node
}

const process = async (parent, args, ctx, info, action) => {
  const { content, name, projectId } = args.input
  let node

  if (action === 'create') {
    const { id } = decodeIdAndCheck(projectId, 'projectId')
    const project = await Project.findByPk(id)

    if (project.userId !== ctx.user.id) {
      throw new UserInputError('Project is not owned by user', {
        invalidArgs: ['projectId']
      })
    }

    node = Icon.build({
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
  node.content = content.trim()
  node.variableName = node.name
    .replace(/[^A-Z0-9]+/ig, '_')
    .replace(/__/g, '_')
    .toUpperCase()

  const isVariableNameUnique = await node.checkUniqueVariableName()

  if (!isVariableNameUnique) {
    throw new UserInputError('Name should be unique', {
      invalidArgs: ['name']
    })
  }

  return node.save()
}

module.exports.resolvers = {
  Mutation: {
    createIcon: async (parent, args, ctx, info) => {
      return process(parent, args, ctx, info, 'create')
    },
    deleteIcon: async (parent, args, ctx, info) => {
      const node = await getNode(parent, args, ctx, info)
      return node.destroy()
    },
    updateIcon: async (parent, args, ctx, info) => {
      return process(parent, args, ctx, info, 'update')
    }
  },
  Icon: {
    project: (parent) => {
      return parent.getProject()
    },
    projectId: (parent) => {
      return encodeId(
        _.upperFirst(Project.options.name.singular),
        parent.projectId
      )
    }
  },
  Query: {
    icons: async (parent, args, ctx) => {
      const { id } = decodeIdAndCheck(args.projectId, 'projectId')
      const project = await Project.findByPk(id)

      if (project.userId !== ctx.user.id) {
        throw new UserInputError('Project is not owned by user', {
          invalidArgs: ['projectId']
        })
      }

      return buildConnection(Icon, project, args)
    }
  }
}
