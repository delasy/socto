import React from 'react'
import Link from 'next/link'
import PropTypes from 'prop-types'
import classnames from 'classnames'

const FileRow = ({
  className: inheritClassName,
  disabled,
  file,
  onDelete,
  project,
  ...props
}) => {
  const className = classnames(inheritClassName, 'file-row')

  const handleDelete = () => {
    const alertmsg = `Do you really want to delete file '${file.name}'?`

    if (window.confirm(alertmsg)) {
      onDelete(file.id)
    }
  }

  return (
    <div className={className} {...props}>
      <h2>
        {file.folder + file.name}
      </h2>
      <p>
        <a
          href={project.publicURL + '/' + file.folder + file.name}
          rel='noopener noreferrer'
          target='_blank'
        >
          {project.publicURL + '/' + file.folder + file.name}
        </a>
      </p>
      <Link
        as={'/account/project/' + project.id + '/file/' + file.id + '/update'}
        href='/account/project/[project-id]/file/[file-id]/update'
      >
        <a>Edit</a>
      </Link>
      <button disabled={disabled} onClick={handleDelete}>
        Delete
      </button>

      <style jsx>
        {`
          .file-row {
            border: 1px solid black;
          }
        `}
      </style>
    </div>
  )
}

FileRow.defaultProps = {
  className: '',
  disabled: false
}

FileRow.propTypes = {
  className: PropTypes.string,
  disabled: PropTypes.bool,
  file: PropTypes.object.isRequired,
  onDelete: PropTypes.func.isRequired,
  project: PropTypes.object.isRequired
}

export default FileRow
