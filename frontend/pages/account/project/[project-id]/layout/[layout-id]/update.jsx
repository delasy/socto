import React, { useState } from 'react'
import Error from 'next/error'
import PropTypes from 'prop-types'
import { useMutation } from '@apollo/client'
import { useRouter } from 'next/router'

import UPDATE_LAYOUT from '~/graphql/mutations/update-layout'
import ProjectLayout from '~/layouts/project'
import VariablesInput from '~/components/variables-input'
import withLayout from '~/middlewares/layout'

const LayoutUpdatePage = ({ layout, project }) => {
  if (layout === null || project === null) {
    return (
      <Error statusCode={404} />
    )
  }

  const router = useRouter()
  const [updateLayout] = useMutation(UPDATE_LAYOUT)
  const [error, setError] = useState()
  const [loading, setLoading] = useState(false)

  const [data, setData] = useState({
    bodyCode: layout.bodyCode,
    headCode: layout.headCode,
    name: layout.name,
    scripts: layout.scripts,
    styles: layout.styles,
    variables: layout.variables.edges.map((edge) => {
      return {
        id: edge.node.variableId,
        value: edge.node.value
      }
    })
  })

  const handleFormBodyCodeChange = (e) => {
    setError()
    setData({ ...data, bodyCode: e.target.value })
  }

  const handleFormHeadCodeChange = (e) => {
    setError()
    setData({ ...data, headCode: e.target.value })
  }

  const handleFormNameChange = (e) => {
    setError()
    setData({ ...data, name: e.target.value })
  }

  const handleFormScriptsChange = (e) => {
    setError()
    setData({ ...data, scripts: e.target.value })
  }

  const handleFormStylesChange = (e) => {
    setError()
    setData({ ...data, styles: e.target.value })
  }

  const handleFormVariablesChange = (variables) => {
    setError()
    setData({ ...data, variables })
  }

  const handleFormSubmit = async (e) => {
    e.preventDefault()

    try {
      setLoading(true)

      await updateLayout({
        variables: {
          id: layout.id,
          input: data
        }
      })

      await router.push('/account/project/' + project.id + '/layouts')
    } catch (err) {
      setError(err)
      setLoading(false)
    }
  }

  return (
    <ProjectLayout project={project}>
      <div className='layout-update-page'>
        <h1>
          Edit Layout
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
              Head Code
            </label>
            <textarea
              autoComplete='off'
              disabled={loading}
              onChange={handleFormHeadCodeChange}
              placeholder='Enter head code'
              value={data.headCode}
            />
          </div>
          <div>
            <label>
              Styles
            </label>
            <textarea
              autoComplete='off'
              disabled={loading}
              onChange={handleFormStylesChange}
              placeholder='Enter styles'
              value={data.styles}
            />
          </div>
          <div>
            <label>
              Body Code
            </label>
            <textarea
              autoComplete='off'
              disabled={loading}
              onChange={handleFormBodyCodeChange}
              placeholder='Enter body code'
              value={data.bodyCode}
            />
          </div>
          <div>
            <label>
              Scripts
            </label>
            <textarea
              autoComplete='off'
              disabled={loading}
              onChange={handleFormScriptsChange}
              placeholder='Enter scripts'
              value={data.scripts}
            />
          </div>
          <div>
            <label>
              Variables
            </label>
            <VariablesInput
              disabled={loading}
              onChange={handleFormVariablesChange}
              project={project}
              value={data.variables}
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
          .layout-update-page {
            position: relative;
          }
        `}
      </style>
    </ProjectLayout>
  )
}

LayoutUpdatePage.propTypes = {
  layout: PropTypes.object,
  project: PropTypes.object
}

export default withLayout(LayoutUpdatePage)
