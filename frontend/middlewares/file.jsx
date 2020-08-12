import React from 'react'
import _ from 'lodash'

import GET_FILE from '~/graphql/queries/get-file'
import withUser from '~/middlewares/user'

export default _.flowRight(withUser, (PageComponent) => {
  const withFile = (props) => {
    return (
      <PageComponent {...props} />
    )
  }

  withFile.getInitialProps = async (ctx) => {
    ctx.file = null
    ctx.project = null

    const { query } = ctx.apolloClient

    try {
      const res = await query({
        fetchPolicy: 'network-only',
        query: GET_FILE,
        variables: {
          id: ctx.query['file-id']
        }
      })

      ctx.file = res.data.node
      ctx.project = ctx.file === null ? null : ctx.file.project
    } catch {
    }

    if (ctx.res && (ctx.file === null || ctx.project === null)) {
      ctx.res.statusCode = 404
    }

    let pageProps = {}

    if (PageComponent.getInitialProps) {
      pageProps = await PageComponent.getInitialProps(ctx)
    }

    return {
      ...pageProps,
      file: ctx.file,
      project: ctx.project
    }
  }

  return withFile
})
