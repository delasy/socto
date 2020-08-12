import React, { useState } from 'react'
import Link from 'next/link'
import { useApolloClient, useMutation } from '@apollo/client'

import DELETE_PROJECT from '~/graphql/mutations/delete-project'
import GET_PROJECTS from '~/graphql/queries/get-projects'
import DefaultLayout from '~/layouts/default'
import ProjectRow from '~/components/project-row'
import ScrollPagination from '~/components/scroll-pagination'
import withUser from '~/middlewares/user'

const AccountPage = () => {
  const apolloClient = useApolloClient()
  const [deleteProject] = useMutation(DELETE_PROJECT)
  const [loading, setLoading] = useState(false)

  const handleDelete = async (id) => {
    setLoading(true)

    await deleteProject({ variables: { id } })
    await apolloClient.resetStore()

    setLoading(false)
  }

  return (
    <DefaultLayout>
      <div className='account-page'>
        <Link href='/auth/signout'>
          <a>Sign Out</a>
        </Link>
        <h1>
          Projects
        </h1>
        <Link href='/account/project/create'>
          <a>Create Project</a>
        </Link>
        <ScrollPagination name='projects' query={GET_PROJECTS}>
          {(project) => {
            return (
              <ProjectRow
                disabled={loading}
                key={project.id}
                onDelete={handleDelete}
                project={project}
              />
            )
          }}
        </ScrollPagination>
      </div>

      <style jsx>
        {`
          .account-page {
            position: relative;
          }
        `}
      </style>
    </DefaultLayout>
  )
}

export default withUser(AccountPage)
