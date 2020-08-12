import React, { useState } from 'react'
import Error from 'next/error'
import Link from 'next/link'
import PropTypes from 'prop-types'
import { useApolloClient, useMutation } from '@apollo/client'

import DELETE_ASSET from '~/graphql/mutations/delete-asset'
import GET_ASSETS from '~/graphql/queries/get-assets'
import AssetRow from '~/components/asset-row'
import ProjectLayout from '~/layouts/project'
import ScrollPagination from '~/components/scroll-pagination'
import withProject from '~/middlewares/project'

const ProjectAssetsPage = ({ project }) => {
  if (project === null) {
    return (
      <Error statusCode={404} />
    )
  }

  const apolloClient = useApolloClient()
  const [deleteAsset] = useMutation(DELETE_ASSET)
  const [loading, setLoading] = useState(false)

  const handleDelete = async (id) => {
    setLoading(true)

    await deleteAsset({ variables: { id } })
    await apolloClient.resetStore()

    setLoading(false)
  }

  return (
    <ProjectLayout project={project}>
      <div className='project-assets-page'>
        <Link href='/auth/signout'>
          <a>Sign Out</a>
        </Link>
        <h1>
          Assets
        </h1>
        <Link
          as={'/account/project/' + project.id + '/asset/create'}
          href='/account/project/[project-id]/asset/create'
        >
          <a>Create Asset</a>
        </Link>
        <ScrollPagination
          name='assets'
          query={GET_ASSETS}
          variables={{
            projectId: project.id
          }}
        >
          {(asset) => {
            return (
              <AssetRow
                asset={asset}
                disabled={loading}
                key={asset.id}
                onDelete={handleDelete}
                project={asset.project}
              />
            )
          }}
        </ScrollPagination>
      </div>

      <style jsx>
        {`
          .project-assets-page {
            position: relative;
          }
        `}
      </style>
    </ProjectLayout>
  )
}

ProjectAssetsPage.propTypes = {
  project: PropTypes.object
}

export default withProject(ProjectAssetsPage)
