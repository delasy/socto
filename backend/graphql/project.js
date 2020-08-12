const AWS = require('aws-sdk')
const Cloudflare = require('cloudflare')
const validator = require('validator')
const _ = require('lodash')
const { UserInputError, gql } = require('apollo-server-express')

const { Project, ProjectVariable, User } = require('../models')
const { buildConnection } = require('./connection')
const { decodeIdAndCheck, encodeId } = require('./node')
const { processVariables } = require('./variable')

module.exports.typeDefs = gql`
  type Project implements Node {
    bucketConfigAWS: ProjectBucketConfigAWS
    bucketProvider: ProjectBucketProvider!
    cdnConfigCloudflare: ProjectCDNConfigCloudflare
    cdnProvider: ProjectCDNProvider
    createdAt: DateTime!
    databaseId: UUID!
    description: String!
    globalBodyCode: String!
    globalHeadCode: String!
    globalScripts: String!
    globalStyles: String!
    id: ID!
    name: String!
    publicURL: String!
    updatedAt: DateTime!
    user: User!
    userId: ID!
    variables (
      after: ID
      before: ID
      first: Int
      last: Int
      orderBy: ProjectVariableOrder = {
        direction: DESC
        field: CREATED_AT
      }
    ): Connection! @user
  }

  type ProjectBucketConfigAWS {
    accessKeyId: String!
    bucketName: String!
    secretAccessKey: String!
  }

  type ProjectCDNConfigCloudflare {
    apiToken: String!
    zoneId: String!
  }

  extend type Mutation {
    createProject (input: CreateProjectInput!): Project! @user
    deleteProject (id: ID!): Project! @user
    updateProject (id: ID!, input: UpdateProjectInput!): Project! @user
  }

  extend type Query {
    projects (
      after: ID
      before: ID
      first: Int
      last: Int
      orderBy: ProjectOrder = {
        direction: DESC
        field: CREATED_AT
      }
    ): Connection! @user
  }

  enum ProjectOrderField {
    NAME
    DESCRIPTION
    PUBLIC_URL
    CREATED_AT
    UPDATED_AT
  }

  enum ProjectBucketProvider {
    AWS
  }

  enum ProjectCDNProvider {
    CLOUDFLARE
  }

  input CreateProjectInput {
    bucketConfigAWS: ProjectBucketConfigAWSInput
    bucketProvider: ProjectBucketProvider!
    cdnConfigCloudflare: ProjectCDNConfigCloudflareInput
    cdnProvider: ProjectCDNProvider
    description: String!
    globalBodyCode: String!
    globalHeadCode: String!
    globalScripts: String!
    globalStyles: String!
    name: String!
    publicURL: String!
  }

  input ProjectBucketConfigAWSInput {
    accessKeyId: String!
    bucketName: String!
    secretAccessKey: String!
  }

  input ProjectCDNConfigCloudflareInput {
    apiToken: String!
    zoneId: String!
  }

  input ProjectOrder {
    direction: OrderDirection!
    field: ProjectOrderField!
  }

  input UpdateProjectInput {
    bucketConfigAWS: ProjectBucketConfigAWSInput
    bucketProvider: ProjectBucketProvider!
    cdnConfigCloudflare: ProjectCDNConfigCloudflareInput
    cdnProvider: ProjectCDNProvider
    description: String!
    globalBodyCode: String!
    globalHeadCode: String!
    globalScripts: String!
    globalStyles: String!
    name: String!
    publicURL: String!
    variables: [ProjectVariableInput!]!
  }
`

const getNode = async (parent, args, ctx) => {
  const { id } = decodeIdAndCheck(args.id)

  const nodes = await ctx.user.getProjects({
    where: { id }
  })

  const node = nodes[0] || null

  if (node === null) {
    throw new UserInputError('Invalid id', {
      invalidArgs: ['id']
    })
  }

  return node
}

const process = async (parent, args, ctx, info, action) => {
  let node

  if (action === 'create') {
    node = node = Project.build({
      userId: ctx.user.id
    })
  } else {
    node = await getNode(parent, args, ctx, info)
  }

  const {
    bucketConfigAWS,
    bucketProvider,
    cdnConfigCloudflare,
    cdnProvider,
    description,
    globalHeadCode,
    globalStyles,
    globalBodyCode,
    globalScripts,
    name,
    publicURL
  } = args.input

  if (!validator.isLength(name, { min: 1, max: 255 })) {
    throw new UserInputError('Invalid name', {
      invalidArgs: ['name']
    })
  } else if (!validator.isLength(description, { max: 255 })) {
    throw new UserInputError('Invalid description', {
      invalidArgs: ['description']
    })
  }

  node.name = name.trim()
  node.description = description.trim()

  const isNameUnique = await node.checkUniqueName()

  if (!isNameUnique) {
    throw new UserInputError('Name should be unique', {
      invalidArgs: ['name']
    })
  }

  const validPublicURL = validator.isURL(publicURL, {
    allow_protocol_relative_urls: false,
    allow_trailing_dot: false,
    allow_underscores: false,
    disallow_auth: true,
    host_blacklist: false,
    host_whitelist: false,
    protocols: ['http', 'https'],
    require_host: true,
    require_protocol: true,
    require_tld: true,
    require_valid_protocol: true,
    validate_length: true
  })

  if (!validPublicURL) {
    throw new UserInputError('Invalid public URL', {
      invalidArgs: ['publicURL']
    })
  }

  node.publicURL = publicURL.trim()
  node.bucketProvider = bucketProvider
  node.bucketConfigAWS = null

  switch (node.bucketProvider) {
    case 'AWS': {
      const { accessKeyId, bucketName, secretAccessKey } = bucketConfigAWS
      const credentials = new AWS.Credentials(accessKeyId, secretAccessKey)

      try {
        const sts = new AWS.STS({ credentials })
        await sts.getCallerIdentity().promise()
      } catch {
        throw new UserInputError(
          'Invalid AWS access key id or AWS secret access key',
          {
            invalidArgs: [
              'bucketConfigAWS.accessKeyId',
              'bucketConfigAWS.secretAccessKey'
            ]
          }
        )
      }

      try {
        const s3 = new AWS.S3({ credentials })
        await s3.headBucket({ Bucket: bucketName }).promise()
      } catch {
        throw new UserInputError('Invalid AWS bucket name', {
          invalidArgs: ['bucketConfigAWS.bucketName']
        })
      }

      node.bucketConfigAWS = bucketConfigAWS
      break
    }
  }

  node.cdnProvider = cdnProvider
  node.cdnConfigCloudflare = null

  switch (node.cdnProvider) {
    case 'CLOUDFLARE': {
      const { apiToken, zoneId } = cdnConfigCloudflare
      const cloudflare = new Cloudflare({ token: apiToken })

      try {
        const res = await cloudflare.user.read()

        if (!res.success) {
          throw new Error()
        }
      } catch {
        throw new UserInputError('Invalid Cloudflare API Token', {
          invalidArgs: ['cdnConfigCloudflare.apiToken']
        })
      }

      try {
        const res = await cloudflare.zones.read(zoneId)

        if (!res.success) {
          throw new Error()
        }
      } catch {
        throw new UserInputError('Invalid Cloudflare Zone ID', {
          invalidArgs: ['cdnConfigCloudflare.zoneId']
        })
      }

      node.cdnConfigCloudflare = cdnConfigCloudflare
      break
    }
  }

  node.globalHeadCode = globalHeadCode
  node.globalStyles = globalStyles

  if (!globalBodyCode.includes('{{ LAYOUT_CONTENT }}')) {
    throw new UserInputError(
      'Global body code should contain LAYOUT_CONTENT variable',
      {
        invalidArgs: ['global_body_code']
      }
    )
  }

  node.globalBodyCode = globalBodyCode
  node.globalScripts = globalScripts

  await node.save()

  if (action === 'update') {
    await processVariables(ProjectVariable, 'project', node, args)
  }

  return node
}

module.exports.resolvers = {
  Mutation: {
    createProject: (parent, args, ctx, info) => {
      return process(parent, args, ctx, info, 'create')
    },
    deleteProject: async (parent, args, ctx, info) => {
      const node = await getNode(parent, args, ctx, info)
      return node.destroy()
    },
    updateProject: (parent, args, ctx, info) => {
      return process(parent, args, ctx, info, 'update')
    }
  },
  Project: {
    user: (parent) => {
      return parent.getUser()
    },
    userId: (parent) => {
      return encodeId(
        _.upperFirst(User.options.name.singular),
        parent.userId
      )
    },
    variables: (parent, args) => {
      return buildConnection(ProjectVariable, parent, args)
    }
  },
  Query: {
    projects: (parent, args, ctx) => {
      return buildConnection(Project, ctx.user, args)
    }
  }
}
