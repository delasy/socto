import React, { useState } from 'react'
import Error from 'next/error'
import PropTypes from 'prop-types'
import { useMutation } from '@apollo/client'
import { useRouter } from 'next/router'

import CREATE_ICON from '~/graphql/mutations/create-icon'
import ProjectLayout from '~/layouts/project'
import withProject from '~/middlewares/project'

const IconCreatePage = ({ project }) => {
  if (project === null) {
    return (
      <Error statusCode={404} />
    )
  }

  const router = useRouter()
  const [createIcon] = useMutation(CREATE_ICON)
  const [error, setError] = useState()
  const [loading, setLoading] = useState(false)

  const [data, setData] = useState({
    content: '',
    name: '',
    projectId: project.id
  })

  const handleFormContentChange = (e) => {
    setError()
    setData({ ...data, content: e.target.value })
  }

  const handleFormNameChange = (e) => {
    setError()
    setData({ ...data, name: e.target.value })
  }

  const handleFormSubmit = async (e) => {
    e.preventDefault()

    try {
      setLoading(true)

      await createIcon({
        variables: {
          input: data
        }
      })

      await router.push('/account/project/' + project.id + '/icons')
    } catch (err) {
      setError(err)
      setLoading(false)
    }
  }

  return (
    <ProjectLayout project={project}>
      <div className='icon-create-page'>
        <h1>
          Create Icon
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
          <div>
            <label>
              Content
            </label>
            <textarea
              autoComplete='off'
              disabled={loading}
              onChange={handleFormContentChange}
              placeholder='Enter content'
              value={data.content}
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
          .icon-create-page {
            position: relative;
          }
        `}
      </style>
    </ProjectLayout>
  )
}

IconCreatePage.propTypes = {
  project: PropTypes.object
}

export default withProject(IconCreatePage)
