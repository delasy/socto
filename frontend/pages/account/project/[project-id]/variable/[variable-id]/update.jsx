import React, { useState } from 'react'
import Error from 'next/error'
import PropTypes from 'prop-types'
import { useMutation } from '@apollo/client'
import { useRouter } from 'next/router'

import UPDATE_VARIABLE from '~/graphql/mutations/update-variable'
import ProjectLayout from '~/layouts/project'
import withVariable from '~/middlewares/variable'

const VariableUpdatePage = ({ project, variable }) => {
  if (variable === null || project === null) {
    return (
      <Error statusCode={404} />
    )
  }

  const router = useRouter()
  const [updateVariable] = useMutation(UPDATE_VARIABLE)
  const [error, setError] = useState()
  const [loading, setLoading] = useState(false)

  const [data, setData] = useState({
    name: variable.name
  })

  const handleFormNameChange = (e) => {
    setError()
    setData({ ...data, name: e.target.value })
  }

  const handleFormSubmit = async (e) => {
    e.preventDefault()

    try {
      setLoading(true)

      await updateVariable({
        variables: {
          id: variable.id,
          input: data
        }
      })

      await router.push('/account/project/' + project.id + '/variables')
    } catch (err) {
      setError(err)
      setLoading(false)
    }
  }

  return (
    <ProjectLayout project={project}>
      <div className='variable-update-page'>
        <h1>
          Edit Variable
        </h1>
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
        <form onSubmit={handleFormSubmit}>
          <div>
            <label>
              Name
            </label>
            <input
              autoComplete='off'
              autoFocus
              disabled={loading}
              onChange={handleFormNameChange}
              placeholder='Enter name'
              required
              value={data.name}
            />
          </div>
          <button
            disabled={typeof error !== 'undefined' || loading}
            type='submit'
          >
            Save
          </button>
        </form>
      </div>

      <style jsx>
        {`
          .variable-update-page {
            position: relative;
          }
        `}
      </style>
    </ProjectLayout>
  )
}

VariableUpdatePage.propTypes = {
  project: PropTypes.object,
  variable: PropTypes.object
}

export default withVariable(VariableUpdatePage)
