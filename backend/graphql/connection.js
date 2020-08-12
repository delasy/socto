const Sequelize = require('sequelize')
const _ = require('lodash')
const { UserInputError, gql } = require('apollo-server-express')

const { encodeId, decodeIdAndCheck } = require('./node')

const MODES = {
  AFTER_FIRST: 'AFTER_FIRST',
  BEFORE_LAST: 'BEFORE_LAST'
}

module.exports.typeDefs = gql`
  type Connection {
    edges: [Edge!]!
    nodes: [Node!]!
    pageInfo: PageInfo!
    totalCount: Int!
  }

  type Edge {
    cursor: ID!
    node: Node!
  }

  type PageInfo {
    endCursor: ID
    hasNextPage: Boolean!
    hasPreviousPage: Boolean!
    startCursor: ID
  }

  enum OrderDirection {
    ASC
    DESC
  }
`

module.exports.buildConnection = async (Model, association, args) => {
  const { after, before, first, last, orderBy } = args

  const modelName = Model.options.name
  const countMethodName = 'count' + _.upperFirst(modelName.plural)
  const findAllMethodName = 'get' + _.upperFirst(modelName.plural)
  const modelNameSingular = _.upperFirst(modelName.singular)
  const orderByField = Model.orderMap[orderBy.field]

  const options = {
    order: [
      [orderByField, orderBy.direction]
    ]
  }

  let mode = MODES.AFTER_FIRST

  if (after || first) {
    mode = MODES.AFTER_FIRST

    if (after) {
      const { id } = decodeIdAndCheck(after, 'after')

      const nodes = await association[findAllMethodName]({
        where: { id }
      })

      const node = nodes[0]

      if (node === null) {
        throw new UserInputError('Invalid after', {
          invalidArgs: ['after']
        })
      }

      options.where = {
        id: {
          [Sequelize.Op.ne]: node.id
        },
        [orderByField]: {
          [Sequelize.Op.lt]: node[orderByField]
        }
      }
    }

    if (first) {
      if (first < 0) {
        throw new UserInputError('Invalid first', {
          invalidArgs: ['first']
        })
      }

      options.limit = first
    }
  } else if (before || last) {
    mode = MODES.BEFORE_LAST

    if (before) {
      const { id } = decodeIdAndCheck(before, 'before')

      const nodes = await association[findAllMethodName]({
        where: { id }
      })

      const node = nodes[0]

      if (node === null) {
        throw new UserInputError('Invalid before', {
          invalidArgs: ['before']
        })
      }

      options.where = {
        id: {
          [Sequelize.Op.ne]: node.id
        },
        [orderByField]: {
          [Sequelize.Op.lt]: node[orderByField]
        }
      }
    }

    if (last) {
      if (last < 0) {
        throw new UserInputError('Invalid last', {
          invalidArgs: ['last']
        })
      }

      options.limit = last
    }
  }

  const nodes = await association[findAllMethodName](options)

  const edges = nodes.map((node) => {
    return {
      cursor: encodeId(modelNameSingular, node.id),
      node: node
    }
  })

  const totalCount = await association[countMethodName]()

  const hasPageResult = await association[findAllMethodName]({
    limit: 1,
    offset: options.limit || 0,
    order: options.order,
    where: options.where
  })

  const hasPage = (hasPageResult[0] || null) !== null

  return {
    edges: edges,
    nodes: nodes,
    pageInfo: {
      endCursor: nodes.length > 0
        ? encodeId(modelNameSingular, nodes[nodes.length - 1].id)
        : null,
      hasNextPage: mode === MODES.AFTER_FIRST ? hasPage : false,
      hasPreviousPage: mode === MODES.BEFORE_LAST ? hasPage : false,
      startCursor: nodes.length > 0
        ? encodeId(modelNameSingular, nodes[0].id)
        : null
    },
    totalCount: totalCount
  }
}
