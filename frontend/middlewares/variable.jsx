import React from 'react'
import _ from 'lodash'

import GET_VARIABLE from '~/graphql/queries/get-variable'
import withUser from '~/middlewares/user'

export default _.flowRight(withUser, (PageComponent) => {
  const withVariable = (props) => {
    return (
      <PageComponent {...props} />
    )
  }

  withVariable.getInitialProps = async (ctx) => {
    ctx.project = null
    ctx.variable = null

    const { query } = ctx.apolloClient

    try {
      const res = await query({
        fetchPolicy: 'network-only',
        query: GET_VARIABLE,
        variables: {
          id: ctx.query['variable-id']
        }
      })

      ctx.variable = res.data.node
      ctx.project = ctx.variable === null ? null : ctx.variable.project
    } catch {
    }

    if (ctx.res && (ctx.project === null || ctx.variable === null)) {
      ctx.res.statusCode = 404
    }

    let pageProps = {}

    if (PageComponent.getInitialProps) {
      pageProps = await PageComponent.getInitialProps(ctx)
    }

    return {
      ...pageProps,
      project: ctx.project,
      variable: ctx.variable
    }
  }

  return withVariable
})
