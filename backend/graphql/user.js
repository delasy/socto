const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')
const validator = require('validator')
const { UserInputError, gql } = require('apollo-server-express')

const { User } = require('../models')
const { encodeId } = require('./node')

module.exports.typeDefs = gql`
  type AuthenticateUserPayload {
    token: String!
  }

  type CurrentUser {
    createdAt: DateTime!
    databaseId: UUID!
    email: String!
    firstName: String!
    id: ID!
    lastName: String!
    updatedAt: DateTime!
  }

  type User {
    createdAt: DateTime!
    databaseId: UUID!
    firstName: String!
    id: ID!
    lastName: String!
    updatedAt: DateTime!
  }

  extend type Mutation {
    authenticateUser (
      input: AuthenticateUserInput!
    ): AuthenticateUserPayload! @guest
  }

  extend type Query {
    currentUser: CurrentUser! @user
  }

  input AuthenticateUserInput {
    email: String!
    password: String!
  }
`

module.exports.resolvers = {
  CurrentUser: {
    databaseId: (parent) => {
      return parent.id
    },
    id: (parent, args, ctx, info) => {
      return encodeId(info.parentType, parent.id)
    }
  },
  Mutation: {
    authenticateUser: async (parent, args) => {
      const { email, password } = args.input

      if (!validator.isEmail(email)) {
        throw new UserInputError('Invalid email', {
          invalidArgs: ['email']
        })
      } else if (!validator.isLength(password, { min: 6 })) {
        throw new UserInputError('Invalid password', {
          invalidArgs: ['password']
        })
      }

      const user = await User.findOneByEmail(email)

      if (user === null) {
        throw new UserInputError('Invalid email or password', {
          invalidArgs: ['email', 'password']
        })
      }

      const passwordsMatch = await bcrypt.compare(password, user.password)

      if (!passwordsMatch) {
        throw new UserInputError('Invalid email or password', {
          invalidArgs: ['email', 'password']
        })
      }

      const token = jwt.sign({ userId: user.id }, process.env.SECRET, {
        expiresIn: '7d'
      })

      return { token }
    }
  },
  Query: {
    currentUser: (parent, args, ctx) => {
      return ctx.user
    }
  },
  User: {
    databaseId: (parent) => {
      return parent.id
    },
    id: (parent, args, ctx, info) => {
      return encodeId(info.parentType, parent.id)
    }
  }
}
