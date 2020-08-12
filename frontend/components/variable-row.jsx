import React from 'react'
import Link from 'next/link'
import PropTypes from 'prop-types'
import classnames from 'classnames'

const VariableRow = ({
  className: inheritClassName,
  disabled,
  onDelete,
  project,
  variable,
  ...props
}) => {
  const className = classnames(inheritClassName, 'variable-row')

  const handleDelete = () => {
    const alertmsg = 'Do you really want to delete variable ' +
      `'${variable.name}'?`

    if (window.confirm(alertmsg)) {
      onDelete(variable.id)
    }
  }

  return (
    <div className={className} {...props}>
      <h2>
        {variable.name}
      </h2>
      <Link
        as={
          '/account/project/' + project.id +
          '/variable/' + variable.id + '/update'
        }
        href='/account/project/[project-id]/variable/[variable-id]/update'
      >
        <a>Edit</a>
      </Link>
      <button disabled={disabled} onClick={handleDelete}>
        Delete
      </button>

      <style jsx>
        {`
          .variable-row {
            border: 1px solid black;
          }
        `}
      </style>
    </div>
  )
}

VariableRow.defaultProps = {
  className: '',
  disabled: false
}

VariableRow.propTypes = {
  className: PropTypes.string,
  disabled: PropTypes.bool,
  onDelete: PropTypes.func.isRequired,
  project: PropTypes.object.isRequired,
  variable: PropTypes.object.isRequired
}

export default VariableRow
