import React, { useState } from 'react'
import Error from 'next/error'
import Link from 'next/link'
import PropTypes from 'prop-types'
import { useApolloClient, useMutation } from '@apollo/client'

import DELETE_VARIABLE from '~/graphql/mutations/delete-variable'
import GET_VARIABLES from '~/graphql/queries/get-variables'
import VariableRow from '~/components/variable-row'
import ProjectLayout from '~/layouts/project'
import ScrollPagination from '~/components/scroll-pagination'
import withProject from '~/middlewares/project'

const ProjectVariablesPage = ({ project }) => {
  if (project === null) {
    return (
      <Error statusCode={404} />
    )
  }

  const apolloClient = useApolloClient()
  const [deleteVariable] = useMutation(DELETE_VARIABLE)
  const [loading, setLoading] = useState(false)

  const handleDelete = async (id) => {
    setLoading(true)

    await deleteVariable({ variables: { id } })
    await apolloClient.resetStore()

    setLoading(false)
  }

  return (
    <ProjectLayout project={project}>
      <div className='project-variables-page'>
        <Link href='/auth/signout'>
          <a>Sign Out</a>
        </Link>
        <h1>
          Variables
        </h1>
        <Link
          as={'/account/project/' + project.id + '/variable/create'}
          href='/account/project/[project-id]/variable/create'
        >
          <a>Create Variable</a>
        </Link>
        <ScrollPagination
          name='variables'
          query={GET_VARIABLES}
          variables={{
            projectId: project.id
          }}
        >
          {(variable) => {
            return (
              <VariableRow
                disabled={loading}
                key={variable.id}
                onDelete={handleDelete}
                project={variable.project}
                variable={variable}
              />
            )
          }}
        </ScrollPagination>
      </div>

      <style jsx>
        {`
          .project-variables-page {
            position: relative;
          }
        `}
      </style>
    </ProjectLayout>
  )
}

ProjectVariablesPage.propTypes = {
  project: PropTypes.object
}

export default withProject(ProjectVariablesPage)
