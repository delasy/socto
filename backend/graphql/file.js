const mime = require('mime-types')
const validator = require('validator')
const _ = require('lodash')
const {
  UserInputError,
  ValidationError,
  gql
} = require('apollo-server-express')

const TemplateEngine = require('../template-engine')
const { File, FileVariable, Project, Variable } = require('../models')
const { buildConnection } = require('./connection')
const { decodeIdAndCheck, encodeId } = require('./node')
const { processVariables } = require('./variable')

module.exports.typeDefs = gql`
  type File implements Node {
    cacheTTL: Int!
    content: String!
    createdAt: DateTime!
    databaseId: UUID!
    folder: String!
    id: ID!
    mimeType: String!
    name: String!
    project: Project!
    projectId: ID!
    updatedAt: DateTime!
    variables (
      after: ID
      before: ID
      first: Int
      last: Int
      orderBy: FileVariableOrder = {
        direction: DESC
        field: CREATED_AT
      }
    ): Connection! @user
  }

  extend type Mutation {
    createFile (input: CreateFileInput!): File! @user
    deleteFile (id: ID!): File! @user
    updateFile (id: ID!, input: UpdateFileInput!): File! @user
  }

  extend type Query {
    files (
      after: ID
      before: ID
      first: Int
      last: Int
      orderBy: FileOrder = {
        direction: DESC
        field: CREATED_AT
      }
      projectId: ID!
    ): Connection! @user
  }

  enum FileOrderField {
    NAME
    FOLDER
    CREATED_AT
    UPDATED_AT
  }

  input CreateFileInput {
    cacheTTL: Int!
    content: String!
    folder: String!
    mimeType: String!
    name: String!
    projectId: ID!
    variables: [FileVariableInput!]!
  }

  input FileOrder {
    direction: OrderDirection!
    field: FileOrderField!
  }

  input UpdateFileInput {
    cacheTTL: Int!
    content: String!
    folder: String!
    mimeType: String!
    name: String!
    variables: [FileVariableInput!]!
  }
`

const getNode = async (parent, args, ctx) => {
  const { id } = decodeIdAndCheck(args.id)

  const node = await File.findOne({
    include: [Project],
    where: { id }
  })

  if (node === null) {
    throw new UserInputError('Invalid id', {
      invalidArgs: ['id']
    })
  } else if (node.project.userId !== ctx.user.id) {
    throw new UserInputError('File is not owned by user', {
      invalidArgs: ['id']
    })
  }

  return node
}

const process = async (parent, args, ctx, info, action) => {
  const { cacheTTL, content, folder, mimeType, name, projectId } = args.input
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

    node = File.build({
      projectId: project.id
    })
  } else {
    node = await getNode(parent, args, ctx, info)
    project = node.project
  }

  if (!validator.isLength(name, { min: 1, max: 255 })) {
    throw new UserInputError('Invalid name', {
      invalidArgs: ['name']
    })
  } else if (name.includes('/')) {
    throw new UserInputError('Name can\'t contain slahes', {
      invalidArgs: ['name']
    })
  } else if (folder !== '' && !folder.endsWith('/')) {
    throw new UserInputError('Folder should end with slash', {
      invalidArgs: ['folder']
    })
  }

  const oldpath = node.folder + node.name

  node.name = name.trim()
  node.folder = folder.trim()
  node.content = content.trim()

  const newpath = node.folder + node.name
  const isNameUnique = await node.checkUniqueName()

  if (!isNameUnique) {
    throw new UserInputError('Name should be unique', {
      invalidArgs: ['name']
    })
  } else if (mimeType !== '' && mime.extension(mimeType) === false) {
    throw new UserInputError('Invalid mime type', {
      invalidArgs: ['mimeType']
    })
  }

  node.cacheTTL = cacheTTL
  node.mimeType = mimeType.trim()

  await node.save()
  await processVariables(FileVariable, 'file', node, args)

  let processedContent = null

  try {
    const variables = await node.getAllVariables()
    const vars = Variable.normalizeVars(variables)

    processedContent = TemplateEngine.renderFile(
      newpath,
      node.mimeType,
      node.content,
      vars
    )
  } catch {
    throw new ValidationError('Failed to process')
  }

  try {
    const opts = {
      cacheTTL: node.cacheTTL,
      mimeType: node.mimeType
    }

    if (action === 'create') {
      await project.put(newpath, processedContent, opts)
    } else {
      await project.delete(oldpath)
      await project.put(newpath, processedContent, opts)
    }
  } catch {
    throw new ValidationError('Integration with providers failed')
  }

  return node
}

module.exports.resolvers = {
  Mutation: {
    createFile: (parent, args, ctx, info) => {
      return process(parent, args, ctx, info, 'create')
    },
    deleteFile: async (parent, args, ctx, info) => {
      const node = await getNode(parent, args, ctx, info)

      try {
        await node.project.delete(node.folder + node.name)
      } catch {
        throw new ValidationError('Integration with providers failed')
      }

      return node.destroy()
    },
    updateFile: (parent, args, ctx, info) => {
      return process(parent, args, ctx, info, 'update')
    }
  },
  File: {
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
      return buildConnection(FileVariable, parent, args)
    }
  },
  Query: {
    files: async (parent, args, ctx) => {
      const { id } = decodeIdAndCheck(args.projectId, 'projectId')
      const project = await Project.findByPk(id)

      if (project.userId !== ctx.user.id) {
        throw new UserInputError('Project is not owned by user', {
          invalidArgs: ['projectId']
        })
      }

      return buildConnection(File, project, args)
    }
  }
}
