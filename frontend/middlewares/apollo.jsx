import React from 'react'
import Router from 'next/router'
import nookies from 'nookies'
import { ApolloClient, ApolloProvider, InMemoryCache } from '@apollo/client'
import { createUploadLink } from 'apollo-upload-client'
import { relayStylePagination } from '@apollo/client/utilities'
import { setContext } from '@apollo/client/link/context'

export const apolloHelpers = {
  getToken: (ctx) => {
    const token = nookies.get(ctx).SID
    return token ? 'Bearer ' + token : ''
  },
  onRedirect: async (ctx, url) => {
    if (ctx && ctx.req && ctx.res) {
      ctx.res.writeHead(301, {
        Location: url
      })

      ctx.res.end()
    } else {
      await Router.push(url)
    }
  },
  onSignin: async (ctx, token) => {
    nookies.set(ctx, 'SID', token, {
      maxAge: 24 * 60 * 60,
      path: '/'
    })

    await apolloHelpers.onSigninRedirect(ctx)
  },
  onSigninRedirect: async (ctx) => {
    await apolloHelpers.onRedirect(ctx, '/account')
  },
  onSignout: async (ctx) => {
    nookies.destroy(ctx, 'SID', {
      path: '/'
    })

    if (ctx && ctx.apolloClient) {
      await ctx.apolloClient.clearStore()
    }

    await apolloHelpers.onSignoutRedirect(ctx)
  },
  onSignoutRedirect: async (ctx) => {
    await apolloHelpers.onRedirect(ctx, '/auth/signin')
  }
}

const createApolloClient = (ctx, initialState) => {
  const httpLink = createUploadLink({
    credentials: 'same-origin',
    uri: process.env.GRAPHQL_ENDPOINT
  })

  const authLink = setContext((_, { headers }) => {
    return {
      headers: {
        ...headers,
        Authorization: apolloHelpers.getToken(ctx)
      }
    }
  })

  return new ApolloClient({
    cache: new InMemoryCache({
      possibleTypes: {
        Node: [
          'Asset',
          'File',
          'FileVariable',
          'Icon',
          'Layout',
          'LayoutVariable',
          'Page',
          'PageVariable',
          'Project',
          'ProjectVariable',
          'Variable'
        ]
      },
      typePolicies: {
        File: {
          variables: relayStylePagination()
        },
        Layout: {
          variables: relayStylePagination()
        },
        Page: {
          variables: relayStylePagination()
        },
        Project: {
          variables: relayStylePagination()
        },
        Query: {
          fields: {
            assets: relayStylePagination(),
            files: relayStylePagination(),
            icons: relayStylePagination(),
            layouts: relayStylePagination(),
            pages: relayStylePagination(),
            projects: relayStylePagination(),
            variables: relayStylePagination()
          }
        }
      }
    }).restore(initialState),
    link: authLink.concat(httpLink),
    ssrMode: typeof window === 'undefined'
  })
}

let globalApolloClient = null

const initApolloClient = (ctx, initialState) => {
  if (typeof window === 'undefined') {
    return createApolloClient(ctx, initialState)
  } else if (globalApolloClient === null) {
    globalApolloClient = createApolloClient(ctx, initialState)
  }

  return globalApolloClient
}

export default (PageComponent) => {
  const withApollo = ({ apolloClient, apolloState, ...pageProps }) => {
    const client = apolloClient || initApolloClient(null, apolloState)

    return (
      <ApolloProvider client={client}>
        <PageComponent {...pageProps} />
      </ApolloProvider>
    )
  }

  withApollo.getInitialProps = async (ctx) => {
    ctx.apolloClient = ctx.apolloClient ||
      initApolloClient(ctx, ctx.apolloState || {})

    let pageProps = {}

    if (PageComponent.getInitialProps) {
      pageProps = await PageComponent.getInitialProps(ctx)
    }

    return {
      ...pageProps,
      apolloState: ctx.apolloClient.cache.extract()
    }
  }

  return withApollo
}
