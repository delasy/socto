const validator = require('validator')
const _ = require('lodash')
const { UserInputError, gql } = require('apollo-server-express')

const { Project, Variable } = require('../models')
const { buildConnection } = require('./connection')
const { decodeIdAndCheck, encodeId } = require('./node')

module.exports.typeDefs = gql`
  type Variable implements Node {
    createdAt: DateTime!
    databaseId: UUID!
    id: ID!
    name: String!
    project: Project!
    projectId: ID!
    updatedAt: DateTime!
  }

  extend type Mutation {
    createVariable (input: CreateVariableInput!): Variable! @user
    deleteVariable (id: ID!): Variable! @user
    updateVariable (id: ID!, input: UpdateVariableInput!): Variable! @user
  }

  extend type Query {
    variables (
      after: ID
      before: ID
      first: Int
      last: Int
      orderBy: VariableOrder = {
        direction: DESC
        field: CREATED_AT
      }
      projectId: ID!
    ): Connection! @user
  }

  enum VariableOrderField {
    NAME
    CREATED_AT
    UPDATED_AT
  }

  input CreateVariableInput {
    name: String!
    projectId: ID!
  }

  input VariableOrder {
    direction: OrderDirection!
    field: VariableOrderField!
  }

  input UpdateVariableInput {
    name: String!
  }
`

const getNode = async (parent, args, ctx) => {
  const { id } = decodeIdAndCheck(args.id)

  const node = await Variable.findOne({
    include: [Project],
    where: { id }
  })

  if (node === null) {
    throw new UserInputError('Invalid id', {
      invalidArgs: ['id']
    })
  } else if (node.project.userId !== ctx.user.id) {
    throw new UserInputError('Variable is not owned by user', {
      invalidArgs: ['id']
    })
  }

  return node
}

const process = async (parent, args, ctx, info, action) => {
  const { name, projectId } = args.input
  let node

  if (action === 'create') {
    const { id } = decodeIdAndCheck(projectId, 'projectId')
    const project = await Project.findByPk(id)

    if (project.userId !== ctx.user.id) {
      throw new UserInputError('Project is not owned by user', {
        invalidArgs: ['projectId']
      })
    }

    node = Variable.build({
      projectId: project.id
    })
  } else {
    node = await getNode(parent, args, ctx, info)
  }

  if (!validator.isLength(name, { min: 1, max: 255 })) {
    throw new UserInputError('Invalid name', {
      invalidArgs: ['name']
    })
  } else if (
    name.startsWith('BUILD_') ||
    name.startsWith('ICON_') ||
    name.startsWith('LAYOUT_') ||
    name.startsWith('PAGE_') ||
    name.startsWith('PROJECT_')
  ) {
    throw new UserInputError(
      'Name can\'t start with BUILD_, ICON_, LAYOUT_, PAGE_, PROJECT_',
      {
        invalidArgs: ['name']
      }
    )
  } else if (name === 'PUBLIC_URL') {
    throw new UserInputError('Name can\'t be PUBLIC_URL', {
      invalidArgs: ['name']
    })
  } else if (!/^[A-Z0-9_]+$/g.test(name)) {
    throw new UserInputError(
      'Only upper case letters, numbers and underscores are allowed',
      {
        invalidArgs: ['name']
      }
    )
  }

  node.name = name.trim()

  const isNameUnique = await node.checkUniqueName()

  if (!isNameUnique) {
    throw new UserInputError('Name should be unique', {
      invalidArgs: ['name']
    })
  }

  return node.save()
}

module.exports.resolvers = {
  Mutation: {
    createVariable: (parent, args, ctx, info) => {
      return process(parent, args, ctx, info, 'create')
    },
    deleteVariable: async (parent, args, ctx, info) => {
      const node = await getNode(parent, args, ctx, info)
      return node.destroy()
    },
    updateVariable: (parent, args, ctx, info) => {
      return process(parent, args, ctx, info, 'update')
    }
  },
  Variable: {
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
    variables: async (parent, args, ctx) => {
      const { id } = decodeIdAndCheck(args.projectId, 'projectId')
      const project = await Project.findByPk(id)

      if (project.userId !== ctx.user.id) {
        throw new UserInputError('Project is not owned by user', {
          invalidArgs: ['projectId']
        })
      }

      return buildConnection(Variable, project, args)
    }
  }
}

module.exports.processVariables = async (Model, key, node, args) => {
  await Model.destroy({
    individualHooks: true,
    where: {
      [key + 'Id']: node.id
    }
  })

  if (args.input.variables.length) {
    const variables = args.input.variables.map((variable) => {
      const { id } = decodeIdAndCheck(variable.id, 'variables')

      return {
        [key + 'Id']: node.id,
        value: variable.value,
        variableId: id
      }
    })

    await Model.bulkCreate(variables)
  }
}
