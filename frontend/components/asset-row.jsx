import React from 'react'
import Link from 'next/link'
import PropTypes from 'prop-types'
import classnames from 'classnames'

const AssetRow = ({
  asset,
  className: inheritClassName,
  disabled,
  onDelete,
  project,
  ...props
}) => {
  const className = classnames(inheritClassName, 'asset-row')

  const handleDelete = () => {
    const alertmsg = `Do you really want to delete asset '${asset.name}'?`

    if (window.confirm(alertmsg)) {
      onDelete(asset.id)
    }
  }

  return (
    <div className={className} {...props}>
      <h2>
        {asset.folder + asset.name}
      </h2>
      <p>
        <a
          href={project.publicURL + '/' + asset.folder + asset.name}
          rel='noopener noreferrer'
          target='_blank'
        >
          {project.publicURL + '/' + asset.folder + asset.name}
        </a>
      </p>
      <Link
        as={
          '/account/project/' + project.id +
          '/asset/' + asset.id + '/update'
        }
        href='/account/project/[project-id]/asset/[asset-id]/update'
      >
        <a>Edit</a>
      </Link>
      <button disabled={disabled} onClick={handleDelete}>
        Delete
      </button>

      <style jsx>
        {`
          .asset-row {
            border: 1px solid black;
          }
        `}
      </style>
    </div>
  )
}

AssetRow.defaultProps = {
  className: '',
  disabled: false
}

AssetRow.propTypes = {
  asset: PropTypes.object.isRequired,
  className: PropTypes.string,
  disabled: PropTypes.bool,
  onDelete: PropTypes.func.isRequired,
  project: PropTypes.object.isRequired
}

export default AssetRow
