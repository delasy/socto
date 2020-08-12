import React from 'react'
import Link from 'next/link'
import PropTypes from 'prop-types'
import classnames from 'classnames'

const ProjectRow = ({
  className: inheritClassName,
  disabled,
  onDelete,
  project,
  ...props
}) => {
  const className = classnames(inheritClassName, 'project-row')

  const handleDelete = () => {
    const alertmsg = `Do you really want to delete project '${project.name}'?`

    if (window.confirm(alertmsg)) {
      onDelete(project.id)
    }
  }

  return (
    <div className={className} {...props}>
      <h2>
        <Link
          as={'/account/project/' + project.id}
          href='/account/project/[project-id]'
        >
          <a>{project.name}</a>
        </Link>
      </h2>
      <p>
        Public URL: {project.publicURL}
      </p>
      {project.description && (
        <p>
          {project.description}
        </p>
      )}
      <Link
        as={'/account/project/' + project.id + '/settings'}
        href='/account/project/[project-id]/settings'
      >
        <a>Settings</a>
      </Link>
      <button disabled={disabled} onClick={handleDelete}>
        Delete
      </button>

      <style jsx>
        {`
          .project-row {
            border: 1px solid black;
          }
        `}
      </style>
    </div>
  )
}

ProjectRow.defaultProps = {
  className: '',
  disabled: false
}

ProjectRow.propTypes = {
  className: PropTypes.string,
  disabled: PropTypes.bool,
  onDelete: PropTypes.func.isRequired,
  project: PropTypes.object.isRequired
}

export default ProjectRow
