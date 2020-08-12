import React from 'react'
import _ from 'lodash'

import GET_PAGE from '~/graphql/queries/get-page'
import withUser from '~/middlewares/user'

export default _.flowRight(withUser, (PageComponent) => {
  const withPage = (props) => {
    return (
      <PageComponent {...props} />
    )
  }

  withPage.getInitialProps = async (ctx) => {
    ctx.layout = null
    ctx.page = null
    ctx.project = null

    const { query } = ctx.apolloClient

    try {
      const res = await query({
        fetchPolicy: 'network-only',
        query: GET_PAGE,
        variables: {
          id: ctx.query['page-id']
        }
      })

      ctx.page = res.data.node
      ctx.layout = ctx.page === null ? null : ctx.page.layout
      ctx.project = ctx.page === null ? null : ctx.page.project
    } catch {
    }

    if (
      ctx.res && (
        ctx.layout === null ||
        ctx.page === null ||
        ctx.project === null
      )
    ) {
      ctx.res.statusCode = 404
    }

    let pageProps = {}

    if (PageComponent.getInitialProps) {
      pageProps = await PageComponent.getInitialProps(ctx)
    }

    return {
      ...pageProps,
      layout: ctx.layout,
      page: ctx.page,
      project: ctx.project
    }
  }

  return withPage
})
