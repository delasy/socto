import React, { useState } from 'react'
import PropTypes from 'prop-types'
import classnames from 'classnames'
import { useApolloClient } from '@apollo/client'

import GET_ALL_PAGES from '~/graphql/queries/get-all-pages'
import PUBLISH_PAGE from '~/graphql/mutations/publish-page'

const PublishAllPages = ({
  className: inheritClassName,
  disabled,
  project,
  ...props
}) => {
  const apolloClient = useApolloClient()
  const [error, setError] = useState()
  const [loading, setLoading] = useState(false)
  const [loadedPages, setLoadedPages] = useState('0')
  const [totalPages, setTotalPages] = useState('N/A')
  const className = classnames(inheritClassName, 'publish-all-pages')

  const handleClick = async () => {
    setLoading(true)

    try {
      setLoadedPages('0')
      setTotalPages('N/A')

      const { mutate, query } = apolloClient

      const queryRes = await query({
        fetchPolicy: 'network-only',
        query: GET_ALL_PAGES,
        variables: {
          projectId: project.id
        }
      })

      const pages = queryRes.data.pages.edges.map((edge) => {
        return edge.node
      })

      setTotalPages(String(pages.length))

      for (let i = 0; i < pages.length; i++) {
        await mutate({
          mutation: PUBLISH_PAGE,
          variables: {
            id: pages[i].id
          }
        })

        setLoadedPages(String(i + 1))
      }

      await apolloClient.resetStore()

      setLoading(false)
    } catch (err) {
      setError(err)
      setLoading(false)
    }
  }

  return (
    <div className={className} {...props}>
      {typeof error !== 'undefined' && (
        error.graphQLErrors && error.graphQLErrors.length ? (
          error.graphQLErrors.map((error, idx) => {
            return (
              <div key={idx} style={{ color: 'red' }}>
                {error.message}
              </div>
            )
          })
        ) : (
          <div style={{ color: 'red' }}>
            {error.message}
          </div>
        )
      )}
      <button disabled={loading || disabled} onClick={handleClick}>
        Publish All Pages
      </button>
      {!loading ? null : (
        <div>
          Published {loadedPages} of {totalPages}
        </div>
      )}

      <style jsx>
        {`
          .publish-all-pages {
            position: relative;
          }
        `}
      </style>
    </div>
  )
}

PublishAllPages.defaultProps = {
  className: '',
  disabled: false
}

PublishAllPages.propTypes = {
  className: PropTypes.string,
  disabled: PropTypes.bool,
  project: PropTypes.object.isRequired
}

export default PublishAllPages
