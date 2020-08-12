import React from 'react'
import _ from 'lodash'

import GET_LAYOUT from '~/graphql/queries/get-layout'
import withUser from '~/middlewares/user'

export default _.flowRight(withUser, (PageComponent) => {
  const withLayout = (props) => {
    return (
      <PageComponent {...props} />
    )
  }

  withLayout.getInitialProps = async (ctx) => {
    ctx.layout = null
    ctx.project = null

    const { query } = ctx.apolloClient

    try {
      const res = await query({
        fetchPolicy: 'network-only',
        query: GET_LAYOUT,
        variables: {
          id: ctx.query['layout-id']
        }
      })

      ctx.layout = res.data.node
      ctx.project = ctx.layout === null ? null : ctx.layout.project
    } catch {
    }

    if (ctx.res && (ctx.layout === null || ctx.project === null)) {
      ctx.res.statusCode = 404
    }

    let pageProps = {}

    if (PageComponent.getInitialProps) {
      pageProps = await PageComponent.getInitialProps(ctx)
    }

    return {
      ...pageProps,
      layout: ctx.layout,
      project: ctx.project
    }
  }

  return withLayout
})
