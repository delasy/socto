const mime = require('mime-types')
const validator = require('validator')
const _ = require('lodash')
const {
  UserInputError,
  ValidationError,
  gql
} = require('apollo-server-express')

const { Asset, Project } = require('../models')
const { buildConnection } = require('./connection')
const { decodeIdAndCheck, encodeId } = require('./node')

module.exports.typeDefs = gql`
  type Asset implements Node {
    cacheTTL: Int!
    createdAt: DateTime!
    databaseId: UUID!
    folder: String!
    id: ID!
    mimeType: String!
    name: String!
    project: Project!
    projectId: ID!
    updatedAt: DateTime!
  }

  extend type Mutation {
    createAsset (input: CreateAssetInput!): Asset! @user
    deleteAsset (id: ID!): Asset! @user
    updateAsset (id: ID!, input: UpdateAssetInput!): Asset! @user
  }

  extend type Query {
    assets (
      after: ID
      before: ID
      first: Int
      last: Int
      orderBy: AssetOrder = {
        direction: DESC
        field: CREATED_AT
      }
      projectId: ID!
    ): Connection! @user
  }

  enum AssetOrderField {
    NAME
    FOLDER
    CREATED_AT
    UPDATED_AT
  }

  input CreateAssetInput {
    cacheTTL: Int!
    file: Upload!
    folder: String!
    mimeType: String!
    name: String!
    projectId: ID!
  }

  input AssetOrder {
    direction: OrderDirection!
    field: AssetOrderField!
  }

  input UpdateAssetInput {
    cacheTTL: Int!
    folder: String!
    mimeType: String!
    name: String!
  }
`

const getNode = async (parent, args, ctx) => {
  const { id } = decodeIdAndCheck(args.id)

  const node = await Asset.findOne({
    include: [Project],
    where: { id }
  })

  if (node === null) {
    throw new UserInputError('Invalid id', {
      invalidArgs: ['id']
    })
  } else if (node.project.userId !== ctx.user.id) {
    throw new UserInputError('Asset is not owned by user', {
      invalidArgs: ['id']
    })
  }

  return node
}

const process = async (parent, args, ctx, info, action) => {
  const { cacheTTL, folder, mimeType, name, projectId } = args.input
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

    node = Asset.build({
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

  try {
    if (action === 'create') {
      const file = await args.input.file

      await project.upload(newpath, file.createReadStream(), {
        cacheTTL: node.cacheTTL,
        mimeType: node.mimeType || file.mimetype
      })
    } else {
      await project.copy(oldpath, newpath, {
        cacheTTL: node.cacheTTL,
        mimeType: node.mimeType
      })

      if (oldpath !== newpath) {
        await project.delete(oldpath)
      }
    }
  } catch {
    throw new ValidationError('Integration with providers failed')
  }

  return node
}

module.exports.resolvers = {
  Mutation: {
    createAsset: (parent, args, ctx, info) => {
      return process(parent, args, ctx, info, 'create')
    },
    deleteAsset: async (parent, args, ctx, info) => {
      const node = await getNode(parent, args, ctx, info)

      try {
        await node.project.delete(node.folder + node.name)
      } catch {
        throw new ValidationError('Integration with providers failed')
      }

      return node.destroy()
    },
    updateAsset: async (parent, args, ctx, info) => {
      return process(parent, args, ctx, info, 'update')
    }
  },
  Asset: {
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
    assets: async (parent, args, ctx) => {
      const { id } = decodeIdAndCheck(args.projectId, 'projectId')
      const project = await Project.findByPk(id)

      if (project.userId !== ctx.user.id) {
        throw new UserInputError('Project is not owned by user', {
          invalidArgs: ['projectId']
        })
      }

      return buildConnection(Asset, project, args)
    }
  }
}
