import React from 'react'
import PropTypes from 'prop-types'
import classnames from 'classnames'
import { useQuery } from '@apollo/client'

import GET_ALL_LAYOUTS from '~/graphql/queries/get-all-layouts'

const LayoutSelect = ({
  className: inheritClassName,
  disabled,
  onChange,
  project,
  value,
  ...props
}) => {
  const { data: layoutsData, error, loading } = useQuery(GET_ALL_LAYOUTS, {
    fetchPolicy: 'network-only',
    variables: {
      projectId: project.id
    }
  })

  const className = classnames(inheritClassName, 'layout-select')

  const handleSelect = (e) => {
    onChange(e.target.value)
  }

  if (loading) {
    return (
      <p>
        Loading...
      </p>
    )
  }

  const layouts = layoutsData.layouts.edges.map((edge) => {
    return edge.node
  })

  return (
    <div>
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

      <select
        autoComplete='off'
        className={className}
        disabled={disabled}
        onChange={handleSelect}
        value={value}
        {...props}
      >
        <option disabled value=''>Select layout</option>
        {layouts.map((layout) => {
          return (
            <option key={layout.id} value={layout.id}>
              {layout.name}
            </option>
          )
        })}
      </select>

      <style jsx>
        {`
          .layout-select {
            position: relative;
          }
        `}
      </style>
    </div>
  )
}

LayoutSelect.defaultProps = {
  className: '',
  disabled: false
}

LayoutSelect.propTypes = {
  className: PropTypes.string,
  disabled: PropTypes.bool,
  onChange: PropTypes.func.isRequired,
  project: PropTypes.object.isRequired,
  value: PropTypes.string.isRequired
}

export default LayoutSelect
