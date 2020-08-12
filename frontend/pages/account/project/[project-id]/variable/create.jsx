import React, { useState } from 'react'
import Error from 'next/error'
import PropTypes from 'prop-types'
import { useMutation } from '@apollo/client'
import { useRouter } from 'next/router'

import CREATE_VARIABLE from '~/graphql/mutations/create-variable'
import ProjectLayout from '~/layouts/project'
import withProject from '~/middlewares/project'

const VariableCreatePage = ({ project }) => {
  if (project === null) {
    return (
      <Error statusCode={404} />
    )
  }

  const router = useRouter()
  const [createVariable] = useMutation(CREATE_VARIABLE)
  const [error, setError] = useState()
  const [loading, setLoading] = useState(false)

  const [data, setData] = useState({
    name: '',
    projectId: project.id
  })

  const handleFormNameChange = (e) => {
    setError()
    setData({ ...data, name: e.target.value })
  }

  const handleFormSubmit = async (e) => {
    e.preventDefault()

    try {
      setLoading(true)

      await createVariable({
        variables: {
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
      <div className='variable-create-page'>
        <h1>
          Create Variable
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
            Create
          </button>
        </form>
      </div>

      <style jsx>
        {`
          .variable-create-page {
            position: relative;
          }
        `}
      </style>
    </ProjectLayout>
  )
}

VariableCreatePage.propTypes = {
  project: PropTypes.object
}

export default withProject(VariableCreatePage)
