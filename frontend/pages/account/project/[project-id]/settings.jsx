import React, { useState } from 'react'
import Error from 'next/error'
import PropTypes from 'prop-types'
import { useMutation } from '@apollo/client'
import { useRouter } from 'next/router'

import UPDATE_PROJECT from '~/graphql/mutations/update-project'
import ProjectLayout from '~/layouts/project'
import VariablesInput from '~/components/variables-input'
import withProject from '~/middlewares/project'

const ProjectSettingsPage = ({ project }) => {
  if (project === null) {
    return (
      <Error statusCode={404} />
    )
  }

  const router = useRouter()
  const [updateProject] = useMutation(UPDATE_PROJECT)
  const [error, setError] = useState()
  const [loading, setLoading] = useState(false)

  const [data, setData] = useState({
    bucketConfigAWS: project.bucketConfigAWS === null ? null : {
      accessKeyId: project.bucketConfigAWS.accessKeyId,
      bucketName: project.bucketConfigAWS.bucketName,
      secretAccessKey: project.bucketConfigAWS.secretAccessKey
    },
    bucketProvider: project.bucketProvider,
    cdnConfigCloudflare: project.cdnConfigCloudflare === null ? null : {
      apiToken: project.cdnConfigCloudflare.apiToken,
      zoneId: project.cdnConfigCloudflare.zoneId
    },
    cdnProvider: project.cdnProvider,
    globalBodyCode: project.globalBodyCode,
    globalHeadCode: project.globalHeadCode,
    globalScripts: project.globalScripts,
    globalStyles: project.globalStyles,
    description: project.description,
    name: project.name,
    publicURL: project.publicURL,
    variables: project.variables.edges.map((edge) => {
      return {
        id: edge.node.variableId,
        value: edge.node.value
      }
    })
  })

  const handleFormBucketConfigAWSAccessKeyIdChange = (e) => {
    setError()

    setData({
      ...data,
      bucketConfigAWS: {
        ...data.bucketConfigAWS,
        accessKeyId: e.target.value
      }
    })
  }

  const handleFormBucketConfigAWSBucketNameChange = (e) => {
    setError()

    setData({
      ...data,
      bucketConfigAWS: {
        ...data.bucketConfigAWS,
        bucketName: e.target.value
      }
    })
  }

  const handleFormBucketConfigAWSSecretAccessKeyChange = (e) => {
    setError()

    setData({
      ...data,
      bucketConfigAWS: {
        ...data.bucketConfigAWS,
        secretAccessKey: e.target.value
      }
    })
  }

  const handleFormBucketProviderChange = (e) => {
    setError()

    const newData = {
      ...data,
      bucketConfigAWS: null,
      bucketProvider: e.target.value
    }

    switch (newData.bucketProvider) {
      case 'AWS': {
        newData.bucketConfigAWS = {
          accessKeyId: '',
          bucketName: '',
          secretAccessKey: ''
        }

        break
      }
    }

    setData(newData)
  }

  const handleFormCDNConfigCloudflareAPITokenChange = (e) => {
    setError()

    setData({
      ...data,
      cdnConfigCloudflare: {
        ...data.cdnConfigCloudflare,
        apiToken: e.target.value
      }
    })
  }

  const handleFormCDNConfigCloudflareZoneIdChange = (e) => {
    setError()

    setData({
      ...data,
      cdnConfigCloudflare: {
        ...data.cdnConfigCloudflare,
        zoneId: e.target.value
      }
    })
  }

  const handleFormCDNProviderChange = (e) => {
    setError()

    const newData = {
      ...data,
      cdnConfigCloudflare: null,
      cdnProvider: e.target.value || null
    }

    switch (newData.cdnProvider) {
      case 'CLOUDFLARE': {
        newData.cdnConfigCloudflare = {
          apiToken: '',
          zoneId: ''
        }

        break
      }
    }

    setData(newData)
  }

  const handleFormDescriptionChange = (e) => {
    setError()
    setData({ ...data, description: e.target.value })
  }

  const handleFormGlobalBodyCodeChange = (e) => {
    setError()
    setData({ ...data, globalBodyCode: e.target.value })
  }

  const handleFormGlobalHeadCodeChange = (e) => {
    setError()
    setData({ ...data, globalHeadCode: e.target.value })
  }

  const handleFormGlobalScriptsChange = (e) => {
    setError()
    setData({ ...data, globalScripts: e.target.value })
  }

  const handleFormGlobalStylesChange = (e) => {
    setError()
    setData({ ...data, globalStyles: e.target.value })
  }

  const handleFormNameChange = (e) => {
    setError()
    setData({ ...data, name: e.target.value })
  }

  const handleFormPublicURLChange = (e) => {
    setError()
    setData({ ...data, publicURL: e.target.value })
  }

  const handleFormVariablesChange = (variables) => {
    setError()
    setData({ ...data, variables })
  }

  const handleFormSubmit = async (e) => {
    e.preventDefault()

    try {
      setLoading(true)

      await updateProject({
        variables: {
          id: project.id,
          input: data
        }
      })

      await router.push('/account')
    } catch (err) {
      setError(err)
      setLoading(false)
    }
  }

  return (
    <ProjectLayout project={project}>
      <div className='project-settings-page'>
        <h1>
          Project Settings
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
              Description
            </label>
            <input
              autoComplete='off'
              disabled={loading}
              onChange={handleFormDescriptionChange}
              placeholder='Enter description'
              value={data.description}
            />
          </div>
          <div>
            <label>
              Public URL
            </label>
            <input
              autoComplete='off'
              disabled={loading}
              onChange={handleFormPublicURLChange}
              placeholder='Enter public URL'
              required
              value={data.publicURL}
            />
          </div>
          <div>
            <label>
              Bucket Provider
            </label>
            <select
              autoComplete='off'
              disabled={loading}
              onChange={handleFormBucketProviderChange}
              required
              value={data.bucketProvider}
            >
              <option disabled value=''>Select bucket provider</option>
              <option value='AWS'>AWS</option>
            </select>
          </div>
          {data.bucketProvider === 'AWS' && (
            <>
              <div>
                <label>
                  Bucket AWS Access Key ID
                </label>
                <input
                  autoComplete='off'
                  disabled={loading}
                  onChange={handleFormBucketConfigAWSAccessKeyIdChange}
                  placeholder='Enter Bucket AWS access key id'
                  required
                  value={data.bucketConfigAWS.accessKeyId}
                />
              </div>
              <div>
                <label>
                  Bucket AWS Secret Access Key
                </label>
                <input
                  autoComplete='off'
                  disabled={loading}
                  onChange={handleFormBucketConfigAWSSecretAccessKeyChange}
                  placeholder='Enter Bucket AWS secret access key'
                  required
                  value={data.bucketConfigAWS.secretAccessKey}
                />
              </div>
              <div>
                <label>
                  Bucket AWS S3 Bucket Name
                </label>
                <input
                  autoComplete='off'
                  disabled={loading}
                  onChange={handleFormBucketConfigAWSBucketNameChange}
                  placeholder='Enter Bucket AWS S3 bucket name'
                  required
                  value={data.bucketConfigAWS.bucketName}
                />
              </div>
            </>
          )}
          <div>
            <label>
              CDN Provider
            </label>
            <select
              autoComplete='off'
              disabled={loading}
              onChange={handleFormCDNProviderChange}
              value={data.cdnProvider || ''}
            >
              <option value=''>Select CDN provider</option>
              <option value='CLOUDFLARE'>Cloudflare</option>
            </select>
          </div>
          {data.cdnProvider === 'CLOUDFLARE' && (
            <>
              <div>
                <label>
                  CDN Cloudflare API Token
                </label>
                <input
                  autoComplete='off'
                  disabled={loading}
                  onChange={handleFormCDNConfigCloudflareAPITokenChange}
                  placeholder='Enter CDN Cloudflare API token'
                  required
                  value={data.cdnConfigCloudflare.apiToken}
                />
              </div>
              <div>
                <label>
                  CDN Cloudflare Zone ID
                </label>
                <input
                  autoComplete='off'
                  disabled={loading}
                  onChange={handleFormCDNConfigCloudflareZoneIdChange}
                  placeholder='Enter CDN Cloudflare zone id'
                  required
                  value={data.cdnConfigCloudflare.zoneId}
                />
              </div>
            </>
          )}
          <div>
            <label>
              Global Head Code
            </label>
            <textarea
              autoComplete='off'
              disabled={loading}
              onChange={handleFormGlobalHeadCodeChange}
              placeholder='Enter global head code'
              value={data.globalHeadCode}
            />
          </div>
          <div>
            <label>
              Global Styles
            </label>
            <textarea
              autoComplete='off'
              disabled={loading}
              onChange={handleFormGlobalStylesChange}
              placeholder='Enter global styles'
              value={data.globalStyles}
            />
          </div>
          <div>
            <label>
              Global Body Code
            </label>
            <textarea
              autoComplete='off'
              disabled={loading}
              onChange={handleFormGlobalBodyCodeChange}
              placeholder='Enter global body code'
              value={data.globalBodyCode}
            />
          </div>
          <div>
            <label>
              Global Scripts
            </label>
            <textarea
              autoComplete='off'
              disabled={loading}
              onChange={handleFormGlobalScriptsChange}
              placeholder='Enter global scripts'
              value={data.globalScripts}
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
          .project-settings-page {
            position: relative;
          }
        `}
      </style>
    </ProjectLayout>
  )
}

ProjectSettingsPage.propTypes = {
  project: PropTypes.object
}

export default withProject(ProjectSettingsPage)
