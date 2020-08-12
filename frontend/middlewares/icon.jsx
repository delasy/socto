import React from 'react'
import _ from 'lodash'

import GET_ICON from '~/graphql/queries/get-icon'
import withUser from '~/middlewares/user'

export default _.flowRight(withUser, (PageComponent) => {
  const withIcon = (props) => {
    return (
      <PageComponent {...props} />
    )
  }

  withIcon.getInitialProps = async (ctx) => {
    ctx.icon = null
    ctx.project = null

    const { query } = ctx.apolloClient

    try {
      const res = await query({
        fetchPolicy: 'network-only',
        query: GET_ICON,
        variables: {
          id: ctx.query['icon-id']
        }
      })

      ctx.icon = res.data.node
      ctx.project = ctx.icon === null ? null : ctx.icon.project
    } catch {
    }

    if (ctx.res && (ctx.icon === null || ctx.project === null)) {
      ctx.res.statusCode = 404
    }

    let pageProps = {}

    if (PageComponent.getInitialProps) {
      pageProps = await PageComponent.getInitialProps(ctx)
    }

    return {
      ...pageProps,
      icon: ctx.icon,
      project: ctx.project
    }
  }

  return withIcon
})
