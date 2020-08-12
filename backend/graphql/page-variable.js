const _ = require('lodash')
const { gql } = require('apollo-server-express')

const { Page, Variable } = require('../models')
const { encodeId } = require('./node')

module.exports.typeDefs = gql`
  type PageVariable implements Node{
    createdAt: DateTime!
    databaseId: UUID!
    id: ID!
    page: Page!
    pageId: ID!
    updatedAt: DateTime!
    value: String!
    variable: Variable!
    variableId: ID!
  }

  enum PageVariableOrderField {
    CREATED_AT
    UPDATED_AT
  }

  input PageVariableInput {
    id: ID!
    value: String!
  }

  input PageVariableOrder {
    direction: OrderDirection!
    field: PageVariableOrderField!
  }
`

module.exports.resolvers = {
  PageVariable: {
    page: (parent) => {
      return parent.getPage()
    },
    pageId: (parent) => {
      return encodeId(
        _.upperFirst(Page.options.name.singular),
        parent.pageId
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
