import React, { useState } from 'react'
import PropTypes from 'prop-types'
import classnames from 'classnames'
import _ from 'lodash'
import { useQuery } from '@apollo/client'

import GET_ALL_VARIABLES from '~/graphql/queries/get-all-variables'

const VariablesInput = ({
  className: inheritClassName,
  disabled,
  onChange,
  project,
  value,
  ...props
}) => {
  const { data: variablesData, error, loading } = useQuery(GET_ALL_VARIABLES, {
    fetchPolicy: 'network-only',
    variables: {
      projectId: project.id
    }
  })

  const [data, setData] = useState({
    id: '',
    value: ''
  })

  const className = classnames(inheritClassName, 'variables-input')

  const handleAdd = () => {
    const newValue = [...value, { ...data }]

    onChange(newValue)
    setData({ id: '', value: '' })
  }

  const handleDelete = (id) => {
    const newValue = [...value]

    const idx = newValue.findIndex((item) => {
      return item.id === id
    })

    newValue.splice(idx, 1)
    onChange(newValue)
  }

  const handleChange = (id, value) => {
    const newValue = [...value]

    const idx = newValue.findIndex((item) => {
      return item.id === id
    })

    newValue[idx] = { ...newValue[idx], value }
    onChange(newValue)
  }

  const handleIdChange = (e) => {
    setData({ ...data, id: e.target.value })
  }

  const handleValueChange = (e) => {
    setData({ ...data, value: e.target.value })
  }

  if (loading) {
    return (
      <p>
        Loading...
      </p>
    )
  }

  const variables = variablesData.variables.edges.map((edge) => {
    return edge.node
  })

  const selectVariables = variables.filter((variable) => {
    return _.findIndex(value, ['id', variable.id]) === -1
  })

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
        {value.map((item) => {
          const variable = _.find(variables, ['id', item.id])

          return (
            <div key={item.id}>
              <input
                disabled
                value={variable.name}
              />
              <input
                autoComplete='off'
                disabled={disabled}
                onChange={(e) => {
                  handleChange(item.id, e.target.value)
                }}
                placeholder='VALUE'
                value={item.value}
              />
              <button
                disabled={disabled}
                onClick={() => {
                  handleDelete(item.id)
                }}
                type='button'
              >
                Delete
              </button>
            </div>
          )
        })}
      </div>
      <div>
        <select
          autoComplete='off'
          disabled={disabled}
          onChange={handleIdChange}
          value={data.id}
        >
          <option disabled value=''>Select variable</option>
          {selectVariables.map((variable) => {
            return (
              <option key={variable.id} value={variable.id}>
                {variable.name}
              </option>
            )
          })}
        </select>
        <input
          autoComplete='off'
          disabled={disabled}
          onChange={handleValueChange}
          placeholder='VALUE'
          value={data.value}
        />
        <button
          disabled={!data.id || disabled}
          onClick={handleAdd}
          type='button'
        >
          Add
        </button>
      </div>

      <style jsx>
        {`
          .variables-input {
            position: relative;
          }
        `}
      </style>
    </div>
  )
}

VariablesInput.defaultProps = {
  className: '',
  disabled: false
}

VariablesInput.propTypes = {
  className: PropTypes.string,
  disabled: PropTypes.bool,
  onChange: PropTypes.func.isRequired,
  project: PropTypes.object.isRequired,
  value: PropTypes.array.isRequired
}

export default VariablesInput
