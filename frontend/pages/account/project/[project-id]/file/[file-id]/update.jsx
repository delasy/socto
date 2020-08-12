import React, { useState } from 'react'
import Error from 'next/error'
import PropTypes from 'prop-types'
import { useMutation } from '@apollo/client'
import { useRouter } from 'next/router'

import UPDATE_FILE from '~/graphql/mutations/update-file'
import NumberInput from '~/components/number-input'
import ProjectLayout from '~/layouts/project'
import VariablesInput from '~/components/variables-input'
import withFile from '~/middlewares/file'

const FileUpdatePage = ({ file, project }) => {
  if (file === null || project === null) {
    return (
      <Error statusCode={404} />
    )
  }

  const router = useRouter()
  const [updateFile] = useMutation(UPDATE_FILE)
  const [error, setError] = useState()
  const [loading, setLoading] = useState(false)

  const [data, setData] = useState({
    cacheTTL: file.cacheTTL,
    content: file.content,
    folder: file.folder,
    mimeType: file.mimeType,
    name: file.name,
    variables: file.variables.edges.map((edge) => {
      return {
        id: edge.node.variableId,
        value: edge.node.value
      }
    })
  })

  const handleFormCacheTTLChange = (cacheTTL) => {
    setError()
    setData({ ...data, cacheTTL })
  }

  const handleFormContentChange = (e) => {
    setError()
    setData({ ...data, content: e.target.value })
  }

  const handleFormFolderChange = (e) => {
    setError()
    setData({ ...data, folder: e.target.value })
  }

  const handleFormMimeTypeChange = (e) => {
    setError()
    setData({ ...data, mimeType: e.target.value })
  }

  const handleFormNameChange = (e) => {
    setError()
    setData({ ...data, name: e.target.value })
  }

  const handleFormVariablesChange = (variables) => {
    setError()
    setData({ ...data, variables })
  }

  const handleFormSubmit = async (e) => {
    e.preventDefault()

    try {
      setLoading(true)

      await updateFile({
        variables: {
          id: file.id,
          input: data
        }
      })

      await router.push('/account/project/' + project.id + '/files')
    } catch (err) {
      setError(err)
      setLoading(false)
    }
  }

  return (
    <ProjectLayout project={project}>
      <div className='file-update-page'>
        <h1>
          Edit File
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
              Folder
            </label>
            <input
              autoComplete='off'
              disabled={loading}
              onChange={handleFormFolderChange}
              placeholder='Enter folder'
              value={data.folder}
            />
          </div>
          <div>
            <label>
              Cache TTL
            </label>
            <NumberInput
              autoComplete='off'
              disabled={loading}
              onChange={handleFormCacheTTLChange}
              placeholder='Enter cache TTL'
              required
              type='number'
              value={data.cacheTTL}
            />
          </div>
          <div>
            <label>
              Mime Type
            </label>
            <input
              autoComplete='off'
              disabled={loading}
              onChange={handleFormMimeTypeChange}
              placeholder='Enter mime type'
              value={data.mimeType}
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
          .file-update-page {
            position: relative;
          }
        `}
      </style>
    </ProjectLayout>
  )
}

FileUpdatePage.propTypes = {
  file: PropTypes.object,
  project: PropTypes.object
}

export default withFile(FileUpdatePage)
