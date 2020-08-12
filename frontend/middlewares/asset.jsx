import React from 'react'
import _ from 'lodash'

import GET_ASSET from '~/graphql/queries/get-asset'
import withUser from '~/middlewares/user'

export default _.flowRight(withUser, (PageComponent) => {
  const withAsset = (props) => {
    return (
      <PageComponent {...props} />
    )
  }

  withAsset.getInitialProps = async (ctx) => {
    ctx.asset = null
    ctx.project = null

    const { query } = ctx.apolloClient

    try {
      const res = await query({
        fetchPolicy: 'network-only',
        query: GET_ASSET,
        variables: {
          id: ctx.query['asset-id']
        }
      })

      ctx.asset = res.data.node
      ctx.project = ctx.asset === null ? null : ctx.asset.project
    } catch {
    }

    if (ctx.res && (ctx.asset === null || ctx.project === null)) {
      ctx.res.statusCode = 404
    }

    let pageProps = {}

    if (PageComponent.getInitialProps) {
      pageProps = await PageComponent.getInitialProps(ctx)
    }

    return {
      ...pageProps,
      asset: ctx.asset,
      project: ctx.project
    }
  }

  return withAsset
})
