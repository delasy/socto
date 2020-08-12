const _ = require('lodash')
const { gql } = require('apollo-server-express')

const { Layout, Variable } = require('../models')
const { encodeId } = require('./node')

module.exports.typeDefs = gql`
  type LayoutVariable implements Node{
    createdAt: DateTime!
    databaseId: UUID!
    id: ID!
    layout: Layout!
    layoutId: ID!
    updatedAt: DateTime!
    value: String!
    variable: Variable!
    variableId: ID!
  }

  enum LayoutVariableOrderField {
    CREATED_AT
    UPDATED_AT
  }

  input LayoutVariableInput {
    id: ID!
    value: String!
  }

  input LayoutVariableOrder {
    direction: OrderDirection!
    field: LayoutVariableOrderField!
  }
`

module.exports.resolvers = {
  LayoutVariable: {
    layout: (parent) => {
      return parent.getLayout()
    },
    layoutId: (parent) => {
      return encodeId(
        _.upperFirst(Layout.options.name.singular),
        parent.layoutId
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
