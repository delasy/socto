import React, { useState } from 'react'
import Error from 'next/error'
import PropTypes from 'prop-types'
import { useMutation } from '@apollo/client'
import { useRouter } from 'next/router'

import UPDATE_PAGE from '~/graphql/mutations/update-page'
import LayoutSelect from '~/components/layout-select'
import ProjectLayout from '~/layouts/project'
import VariablesInput from '~/components/variables-input'
import withPage from '~/middlewares/page'

const PageUpdatePage = ({ layout, page, project }) => {
  if (layout === null || page === null || project === null) {
    return (
      <Error statusCode={404} />
    )
  }

  const router = useRouter()
  const [updatePage] = useMutation(UPDATE_PAGE)
  const [error, setError] = useState()
  const [loading, setLoading] = useState(false)

  const [data, setData] = useState({
    bodyCode: page.bodyCode,
    folder: page.folder,
    headCode: page.headCode,
    layoutId: page.layoutId,
    name: page.name,
    scripts: page.scripts,
    slug: page.slug,
    styles: page.styles,
    variables: page.variables.edges.map((edge) => {
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

  const handleFormLayoutIdChange = (layoutId) => {
    setError()
    setData({ ...data, layoutId })
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

      const newData = { ...data }

      delete newData.folder
      delete newData.slug

      await updatePage({
        variables: {
          id: page.id,
          input: newData
        }
      })

      await router.push('/account/project/' + project.id + '/pages')
    } catch (err) {
      setError(err)
      setLoading(false)
    }
  }

  return (
    <ProjectLayout project={project}>
      <div className='page-update-page'>
        <h1>
          Edit Page
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
              Slug
            </label>
            <input
              autoComplete='off'
              disabled
              placeholder='Enter slug'
              value={data.slug}
            />
          </div>
          <div>
            <label>
              Folder
            </label>
            <input
              autoComplete='off'
              disabled
              placeholder='Enter folder'
              value={data.folder}
            />
          </div>
          <div>
            <label>
              Layout
            </label>
            <LayoutSelect
              autoComplete='off'
              disabled={loading}
              onChange={handleFormLayoutIdChange}
              project={project}
              required
              value={data.layoutId}
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
          .page-update-page {
            position: relative;
          }
        `}
      </style>
    </ProjectLayout>
  )
}

PageUpdatePage.propTypes = {
  layout: PropTypes.object,
  page: PropTypes.object,
  project: PropTypes.object
}

export default withPage(PageUpdatePage)
