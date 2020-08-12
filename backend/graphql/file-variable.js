const _ = require('lodash')
const { gql } = require('apollo-server-express')

const { File, Variable } = require('../models')
const { encodeId } = require('./node')

module.exports.typeDefs = gql`
  type FileVariable implements Node{
    createdAt: DateTime!
    databaseId: UUID!
    id: ID!
    file: File!
    fileId: ID!
    updatedAt: DateTime!
    value: String!
    variable: Variable!
    variableId: ID!
  }

  enum FileVariableOrderField {
    CREATED_AT
    UPDATED_AT
  }

  input FileVariableInput {
    id: ID!
    value: String!
  }

  input FileVariableOrder {
    direction: OrderDirection!
    field: FileVariableOrderField!
  }
`

module.exports.resolvers = {
  FileVariable: {
    file: (parent) => {
      return parent.getFile()
    },
    fileId: (parent) => {
      return encodeId(
        _.upperFirst(File.options.name.singular),
        parent.fileId
      )
    },
    variable: (parent) => {
      return parent.getVariable()
    },
    variableId: (parent) => {
      return encodeId(
        _.upperFirst(Variable.options.name.singular),
        parent.variableId
      )
    }
  }
}
