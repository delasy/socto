import React from 'react'
import Link from 'next/link'
import PropTypes from 'prop-types'
import classnames from 'classnames'

const ProjectLayout = ({
  children,
  className: inheritClassName,
  project,
  ...props
}) => {
  const className = classnames(inheritClassName, 'project-layout')

  return (
    <div className={className} {...props}>
      <header>
        <ul>
          <li>
            <Link href='/account'>
              <a>Account</a>
            </Link>
          </li>
        </ul>
      </header>
      <aside>
        <ul>
          <li>
            <Link
              as={'/account/project/' + project.id + '/assets'}
              href='/account/project/[project-id]/assets'
            >
              <a>Assets</a>
            </Link>
          </li>
          <li>
            <Link
              as={'/account/project/' + project.id + '/files'}
              href='/account/project/[project-id]/files'
            >
              <a>Files</a>
            </Link>
          </li>
          <li>
            <Link
              as={'/account/project/' + project.id + '/icons'}
              href='/account/project/[project-id]/icons'
            >
              <a>Icons</a>
            </Link>
          </li>
          <li>
            <Link
              as={'/account/project/' + project.id + '/layouts'}
              href='/account/project/[project-id]/layouts'
            >
              <a>Layouts</a>
            </Link>
          </li>
          <li>
            <Link
              as={'/account/project/' + project.id + '/pages'}
              href='/account/project/[project-id]/pages'
            >
              <a>Pages</a>
            </Link>
          </li>
          <li>
            <Link
              as={'/account/project/' + project.id + '/variables'}
              href='/account/project/[project-id]/variables'
            >
              <a>Variables</a>
            </Link>
          </li>
        </ul>
      </aside>
      <main>
        {children}
      </main>

      <style jsx>
        {`
          .project-layout {
            position: relative;
          }
        `}
      </style>
    </div>
  )
}

ProjectLayout.defaultProps = {
  children: null,
  className: ''
}

ProjectLayout.propTypes = {
  children: PropTypes.node,
  className: PropTypes.string,
  project: PropTypes.object.isRequired
}

export default ProjectLayout
