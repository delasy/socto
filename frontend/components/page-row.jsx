import React from 'react'
import Link from 'next/link'
import PropTypes from 'prop-types'
import classnames from 'classnames'

const PageRow = ({
  className: inheritClassName,
  disabled,
  layout,
  onDelete,
  onPublish,
  page,
  project,
  ...props
}) => {
  const className = classnames(inheritClassName, 'page-row')

  const handleDelete = () => {
    const alertmsg = `Do you really want to delete page '${page.name}'?`

    if (window.confirm(alertmsg)) {
      onDelete(page.id)
    }
  }

  const handlePublish = () => {
    onPublish(page.id)
  }

  return (
    <div className={className} {...props}>
      <h2>
        {page.name}
      </h2>
      {page.publishedAt !== null && (
        <p>
          <a
            href={project.publicURL + '/' + page.folder + page.slug}
            rel='noopener noreferrer'
            target='_blank'
          >
            {project.publicURL + '/' + page.folder + page.slug}
          </a>
        </p>
      )}
      <p>
        Published At: {page.publishedAt === null ? 'Never' : page.publishedAt}
      </p>
      <Link
        as={'/account/project/' + project.id + '/page/' + page.id + '/update'}
        href='/account/project/[project-id]/page/[page-id]/update'
      >
        <a>Edit</a>
      </Link>
      <button disabled={disabled} onClick={handlePublish}>
        Publish
      </button>
      <button disabled={disabled} onClick={handleDelete}>
        Delete
      </button>

      <style jsx>
        {`
          .page-row {
            border: 1px solid black;
          }
        `}
      </style>
    </div>
  )
}

PageRow.defaultProps = {
  className: '',
  disabled: false
}

PageRow.propTypes = {
  className: PropTypes.string,
  disabled: PropTypes.bool,
  layout: PropTypes.object.isRequired,
  onDelete: PropTypes.func.isRequired,
  onPublish: PropTypes.func.isRequired,
  page: PropTypes.object.isRequired,
  project: PropTypes.object.isRequired
}

export default PageRow
