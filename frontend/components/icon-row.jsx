import React from 'react'
import Link from 'next/link'
import PropTypes from 'prop-types'
import classnames from 'classnames'

const IconRow = ({
  className: inheritClassName,
  disabled,
  icon,
  onDelete,
  project,
  ...props
}) => {
  const className = classnames(inheritClassName, 'icon-row')

  const handleDelete = () => {
    const alertmsg = `Do you really want to delete icon '${icon.name}'?`

    if (window.confirm(alertmsg)) {
      onDelete(icon.id)
    }
  }

  return (
    <div className={className} {...props}>
      <h2>
        {icon.name}
      </h2>
      <p>
        ICON_{icon.variableName}
      </p>
      <Link
        as={'/account/project/' + project.id + '/icon/' + icon.id + '/update'}
        href='/account/project/[project-id]/icon/[icon-id]/update'
      >
        <a>Edit</a>
      </Link>
      <button disabled={disabled} onClick={handleDelete}>
        Delete
      </button>

      <style jsx>
        {`
          .icon-row {
            border: 1px solid black;
          }
        `}
      </style>
    </div>
  )
}

IconRow.defaultProps = {
  className: '',
  disabled: false
}

IconRow.propTypes = {
  className: PropTypes.string,
  disabled: PropTypes.bool,
  icon: PropTypes.object.isRequired,
  onDelete: PropTypes.func.isRequired,
  project: PropTypes.object.isRequired
}

export default IconRow
