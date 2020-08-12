require('dotenv').config()

const path = require('path')

module.exports = {
  env: {
    GRAPHQL_ENDPOINT: process.env.GRAPHQL_ENDPOINT
  },
  redirects: () => {
    return [
      {
        source: '/',
        destination: '/account',
        permanent: true
      }
    ]
  },
  webpack: (config) => {
    config.module.rules.push({
      test: /\.graphql$/,
      exclude: /node_modules/,
      loader: 'graphql-tag/loader'
    })

    config.resolve.alias['~'] = path.resolve(__dirname)
    config.resolve.extensions.push('.graphql')

    return config
  }
}
