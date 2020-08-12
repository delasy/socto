import React, { useState } from 'react'
import Error from 'next/error'
import Link from 'next/link'
import PropTypes from 'prop-types'
import { useApolloClient, useMutation } from '@apollo/client'

import DELETE_ICON from '~/graphql/mutations/delete-icon'
import GET_ICONS from '~/graphql/queries/get-icons'
import IconRow from '~/components/icon-row'
import ProjectLayout from '~/layouts/project'
import ScrollPagination from '~/components/scroll-pagination'
import withProject from '~/middlewares/project'

const ProjectIconsPage = ({ project }) => {
  if (project === null) {
    return (
      <Error statusCode={404} />
    )
  }

  const apolloClient = useApolloClient()
  const [deleteIcon] = useMutation(DELETE_ICON)
  const [loading, setLoading] = useState(false)

  const handleDelete = async (id) => {
    setLoading(true)

    await deleteIcon({ variables: { id } })
    await apolloClient.resetStore()

    setLoading(false)
  }

  return (
    <ProjectLayout project={project}>
      <div className='project-icons-page'>
        <Link href='/auth/signout'>
          <a>Sign Out</a>
        </Link>
        <h1>
          Icons
        </h1>
        <Link
          as={'/account/project/' + project.id + '/icon/create'}
          href='/account/project/[project-id]/icon/create'
        >
          <a>Create Icon</a>
        </Link>
        <ScrollPagination
          name='icons'
          query={GET_ICONS}
          variables={{
            projectId: project.id
          }}
        >
          {(icon) => {
            return (
              <IconRow
                disabled={loading}
                icon={icon}
                key={icon.id}
                onDelete={handleDelete}
                project={icon.project}
              />
            )
          }}
        </ScrollPagination>
      </div>

      <style jsx>
        {`
          .project-icons-page {
            position: relative;
          }
        `}
      </style>
    </ProjectLayout>
  )
}

ProjectIconsPage.propTypes = {
  project: PropTypes.object
}

export default withProject(ProjectIconsPage)
