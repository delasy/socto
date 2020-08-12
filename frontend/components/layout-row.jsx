import React from 'react'
import Link from 'next/link'
import PropTypes from 'prop-types'
import classnames from 'classnames'

const LayoutRow = ({
  className: inheritClassName,
  disabled,
  layout,
  onDelete,
  project,
  ...props
}) => {
  const className = classnames(inheritClassName, 'layout-row')

  const handleDelete = () => {
    const alertmsg = `Do you really want to delete layout '${layout.name}'?`

    if (window.confirm(alertmsg)) {
      onDelete(layout.id)
    }
  }

  return (
    <div className={className} {...props}>
      <h2>
        {layout.name}
      </h2>
      <Link
        as={
          '/account/project/' + project.id +
          '/layout/' + layout.id + '/update'
        }
        href='/account/project/[project-id]/layout/[layout-id]/update'
      >
        <a>Edit</a>
      </Link>
      <button disabled={disabled} onClick={handleDelete}>
        Delete
      </button>

      <style jsx>
        {`
          .layout-row {
            border: 1px solid black;
          }
        `}
      </style>
    </div>
  )
}

LayoutRow.defaultProps = {
  className: '',
  disabled: false
}

LayoutRow.propTypes = {
  className: PropTypes.string,
  disabled: PropTypes.bool,
  layout: PropTypes.object.isRequired,
  onDelete: PropTypes.func.isRequired,
  project: PropTypes.object.isRequired
}

export default LayoutRow
