const _ = require('lodash')
const { gql } = require('apollo-server-express')

const { Project, Variable } = require('../models')
const { encodeId } = require('./node')

module.exports.typeDefs = gql`
  type ProjectVariable implements Node{
    createdAt: DateTime!
    databaseId: UUID!
    id: ID!
    project: Project!
    projectId: ID!
    updatedAt: DateTime!
    value: String!
    variable: Variable!
    variableId: ID!
  }

  enum ProjectVariableOrderField {
    CREATED_AT
    UPDATED_AT
  }

  input ProjectVariableInput {
    id: ID!
    value: String!
  }

  input ProjectVariableOrder {
    direction: OrderDirection!
    field: ProjectVariableOrderField!
  }
`

module.exports.resolvers = {
  ProjectVariable: {
    project: (parent) => {
      return parent.getProject()
    },
    projectId: (parent) => {
      return encodeId(
        _.upperFirst(Project.options.name.singular),
        parent.projectId
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
