import React, { useState } from 'react'
import Error from 'next/error'
import Link from 'next/link'
import PropTypes from 'prop-types'
import { useApolloClient, useMutation } from '@apollo/client'

import DELETE_PAGE from '~/graphql/mutations/delete-page'
import GET_PAGES from '~/graphql/queries/get-pages'
import PUBLISH_PAGE from '~/graphql/mutations/publish-page'
import PageRow from '~/components/page-row'
import ProjectLayout from '~/layouts/project'
import PublishAllPages from '~/components/publish-all-pages'
import ScrollPagination from '~/components/scroll-pagination'
import withProject from '~/middlewares/project'

const ProjectPagesPage = ({ project }) => {
  if (project === null) {
    return (
      <Error statusCode={404} />
    )
  }

  const apolloClient = useApolloClient()
  const [deletePage] = useMutation(DELETE_PAGE)
  const [publishPage] = useMutation(PUBLISH_PAGE)
  const [loading, setLoading] = useState(false)

  const handleDelete = async (id) => {
    setLoading(true)

    await deletePage({ variables: { id } })
    await apolloClient.resetStore()

    setLoading(false)
  }

  const handlePublish = async (id) => {
    setLoading(true)

    await publishPage({ variables: { id } })
    await apolloClient.resetStore()

    setLoading(false)
  }

  return (
    <ProjectLayout project={project}>
      <div className='project-pages-page'>
        <Link href='/auth/signout'>
          <a>Sign Out</a>
        </Link>
        <h1>
          Pages
        </h1>
        <Link
          as={'/account/project/' + project.id + '/page/create'}
          href='/account/project/[project-id]/page/create'
        >
          <a>Create Page</a>
        </Link>
        <PublishAllPages project={project} />
        <ScrollPagination
          name='pages'
          query={GET_PAGES}
          variables={{
            projectId: project.id
          }}
        >
          {(page) => {
            return (
              <PageRow
                disabled={loading}
                key={page.id}
                layout={page.layout}
                onDelete={handleDelete}
                onPublish={handlePublish}
                page={page}
                project={page.project}
              />
            )
          }}
        </ScrollPagination>
      </div>

      <style jsx>
        {`
          .project-pages-page {
            position: relative;
          }
        `}
      </style>
    </ProjectLayout>
  )
}

ProjectPagesPage.propTypes = {
  project: PropTypes.object
}

export default withProject(ProjectPagesPage)
