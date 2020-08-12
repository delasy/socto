import React, { useState } from 'react'
import Error from 'next/error'
import Link from 'next/link'
import PropTypes from 'prop-types'
import { useApolloClient, useMutation } from '@apollo/client'

import DELETE_FILE from '~/graphql/mutations/delete-file'
import GET_FILES from '~/graphql/queries/get-files'
import FileRow from '~/components/file-row'
import ProjectLayout from '~/layouts/project'
import ScrollPagination from '~/components/scroll-pagination'
import withProject from '~/middlewares/project'

const ProjectFilesPage = ({ project }) => {
  if (project === null) {
    return (
      <Error statusCode={404} />
    )
  }

  const apolloClient = useApolloClient()
  const [deleteFile] = useMutation(DELETE_FILE)
  const [loading, setLoading] = useState(false)

  const handleDelete = async (id) => {
    setLoading(true)

    await deleteFile({ variables: { id } })
    await apolloClient.resetStore()

    setLoading(false)
  }

  return (
    <ProjectLayout project={project}>
      <div className='project-files-page'>
        <Link href='/auth/signout'>
          <a>Sign Out</a>
        </Link>
        <h1>
          Files
        </h1>
        <Link
          as={'/account/project/' + project.id + '/file/create'}
          href='/account/project/[project-id]/file/create'
        >
          <a>Create File</a>
        </Link>
        <ScrollPagination
          name='files'
          query={GET_FILES}
          variables={{
            projectId: project.id
          }}
        >
          {(file) => {
            return (
              <FileRow
                disabled={loading}
                file={file}
                key={file.id}
                onDelete={handleDelete}
                project={file.project}
              />
            )
          }}
        </ScrollPagination>
      </div>

      <style jsx>
        {`
          .project-files-page {
            position: relative;
          }
        `}
      </style>
    </ProjectLayout>
  )
}

ProjectFilesPage.propTypes = {
  project: PropTypes.object
}

export default withProject(ProjectFilesPage)
