import React from 'react'
import Link from 'next/link'
import PropTypes from 'prop-types'
import classnames from 'classnames'

const DefaultLayout = ({
  children,
  className: inheritClassName,
  ...props
}) => {
  const className = classnames(inheritClassName, 'default-layout')

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
      <main>
        {children}
      </main>

      <style jsx>
        {`
          .default-layout {
            position: relative;
          }
        `}
      </style>
    </div>
  )
}

DefaultLayout.defaultProps = {
  children: null,
  className: ''
}

DefaultLayout.propTypes = {
  children: PropTypes.node,
  className: PropTypes.string
}

export default DefaultLayout
