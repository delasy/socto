import React, { useEffect } from 'react'
import PropTypes from 'prop-types'
import classnames from 'classnames'
import _ from 'lodash'
import { useQuery } from '@apollo/client'

const ScrollPagination = ({
  children,
  className: inheritClassName,
  name,
  query,
  variables,
  ...props
}) => {
  const { data, error, fetchMore, loading } = useQuery(query, {
    fetchPolicy: 'network-only',
    variables: variables
  })

  const handleWindowScroll = _.debounce(() => {
    const hasNextPage = data[name].pageInfo.hasNextPage
    const bodyHeight = window.innerHeight + document.documentElement.scrollTop
    const scrollHeight = document.documentElement.offsetHeight

    if (!hasNextPage || loading || bodyHeight !== scrollHeight) {
      return
    }

    const variables = {
      after: data[name].pageInfo.endCursor
    }

    return fetchMore({ variables })
  }, 100)

  useEffect(() => {
    window.addEventListener('scroll', handleWindowScroll, {
      passive: true
    })

    return () => {
      window.removeEventListener('scroll', handleWindowScroll, false)
    }
  })

  const className = classnames(inheritClassName, 'scroll-pagination')

  if (loading) {
    return (
      <p>
        Loading...
      </p>
    )
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
      <div>
        {children === null ? null : data[name].edges.map((edge, idx) => {
          return children(edge.node, idx)
        })}
      </div>
      {data[name].edges.length === 0 ? (
        <p>
          No {name}.
        </p>
      ) : !data[name].pageInfo.hasNextPage && (
        <p>
          No more {name}.
        </p>
      )}

      <style jsx>
        {`
          .scroll-pagination {
            position: relative;
          }
        `}
      </style>
    </div>
  )
}

ScrollPagination.defaultProps = {
  children: null,
  className: '',
  variables: {}
}

ScrollPagination.propTypes = {
  children: PropTypes.func,
  className: PropTypes.string,
  name: PropTypes.string.isRequired,
  query: PropTypes.object.isRequired,
  variables: PropTypes.object
}

export default ScrollPagination
