import React from 'react'
import Error from 'next/error'
import PropTypes from 'prop-types'

import ProjectLayout from '~/layouts/project'
import withProject from '~/middlewares/project'

const ProjectPage = ({ project }) => {
  if (project === null) {
    return (
      <Error statusCode={404} />
    )
  }

  return (
    <ProjectLayout project={project}>
      <div className='project-page'>
        <h1>
          Project '{project.name}'
        </h1>
      </div>

      <style jsx>
        {`
          .project-page {
            position: relative;
          }
        `}
      </style>
    </ProjectLayout>
  )
}

ProjectPage.propTypes = {
  project: PropTypes.object
}

export default withProject(ProjectPage)
