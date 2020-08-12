import React, { useState } from 'react'
import Error from 'next/error'
import Link from 'next/link'
import PropTypes from 'prop-types'
import { useApolloClient, useMutation } from '@apollo/client'

import DELETE_LAYOUT from '~/graphql/mutations/delete-layout'
import GET_LAYOUTS from '~/graphql/queries/get-layouts'
import LayoutRow from '~/components/layout-row'
import ProjectLayout from '~/layouts/project'
import ScrollPagination from '~/components/scroll-pagination'
import withProject from '~/middlewares/project'

const ProjectLayoutsPage = ({ project }) => {
  if (project === null) {
    return (
      <Error statusCode={404} />
    )
  }

  const apolloClient = useApolloClient()
  const [deleteLayout] = useMutation(DELETE_LAYOUT)
  const [loading, setLoading] = useState(false)

  const handleDelete = async (id) => {
    setLoading(true)

    await deleteLayout({ variables: { id } })
    await apolloClient.resetStore()

    setLoading(false)
  }

  return (
    <ProjectLayout project={project}>
      <div className='project-layouts-page'>
        <Link href='/auth/signout'>
          <a>Sign Out</a>
        </Link>
        <h1>
          Layouts
        </h1>
        <Link
          as={'/account/project/' + project.id + '/layout/create'}
          href='/account/project/[project-id]/layout/create'
        >
          <a>Create Layout</a>
        </Link>
        <ScrollPagination
          name='layouts'
          query={GET_LAYOUTS}
          variables={{
            projectId: project.id
          }}
        >
          {(layout) => {
            return (
              <LayoutRow
                disabled={loading}
                key={layout.id}
                layout={layout}
                onDelete={handleDelete}
                project={layout.project}
              />
            )
          }}
        </ScrollPagination>
      </div>

      <style jsx>
        {`
          .project-layouts-page {
            position: relative;
          }
        `}
      </style>
    </ProjectLayout>
  )
}

ProjectLayoutsPage.propTypes = {
  project: PropTypes.object
}

export default withProject(ProjectLayoutsPage)
