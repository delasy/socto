require('dotenv').config()

const express = require('express')
const helmet = require('helmet')
const { ApolloServer } = require('apollo-server-express')
const { graphqlUploadExpress } = require('graphql-upload')

const GraphQLSchema = require('./graphql')

const server = new ApolloServer(GraphQLSchema)
const app = express()

app.set('trust proxy', true)
app.use(helmet())
app.use(graphqlUploadExpress({ maxFileSize: 1000000000, maxFiles: 1 }))
app.use(express.static('public'))

server.applyMiddleware({ app })

app.listen(process.env.PORT || 8081)
