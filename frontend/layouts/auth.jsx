import React from 'react'
import PropTypes from 'prop-types'
import classnames from 'classnames'

const AuthLayout = ({ children, className: inheritClassName, ...props }) => {
  const className = classnames(inheritClassName, 'auth-layout')

  return (
    <div className={className} {...props}>
      <main>
        {children}
      </main>

      <style jsx>
        {`
          .auth-layout {
            position: relative;
          }
        `}
      </style>
    </div>
  )
}

AuthLayout.defaultProps = {
  children: null,
  className: ''
}

AuthLayout.propTypes = {
  children: PropTypes.node,
  className: PropTypes.string
}

export default AuthLayout
