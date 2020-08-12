import React from 'react'
import _ from 'lodash'

import GET_PROJECT from '~/graphql/queries/get-project'
import withUser from '~/middlewares/user'

export default _.flowRight(withUser, (PageComponent) => {
  const withProject = (props) => {
    return (
      <PageComponent {...props} />
    )
  }

  withProject.getInitialProps = async (ctx) => {
    ctx.project = null

    const { query } = ctx.apolloClient

    try {
      const res = await query({
        fetchPolicy: 'network-only',
        query: GET_PROJECT,
        variables: {
          id: ctx.query['project-id']
        }
      })

      ctx.project = res.data.node
    } catch {
    }

    if (ctx.res && ctx.project === null) {
      ctx.res.statusCode = 404
    }

    let pageProps = {}

    if (PageComponent.getInitialProps) {
      pageProps = await PageComponent.getInitialProps(ctx)
    }

    return {
      ...pageProps,
      project: ctx.project
    }
  }

  return withProject
})
