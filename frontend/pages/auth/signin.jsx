import React, { useState } from 'react'
import { useMutation } from '@apollo/client'

import AUTHENTICATE_USER from '~/graphql/mutations/authenticate-user'
import AuthLayout from '~/layouts/auth'
import withGuest from '~/middlewares/guest'
import { apolloHelpers } from '~/middlewares/apollo'

const AuthSigninPage = () => {
  const [authenticateUser] = useMutation(AUTHENTICATE_USER)
  const [error, setError] = useState()
  const [loading, setLoading] = useState(false)

  const [data, setData] = useState({
    email: '',
    password: ''
  })

  const handleFormEmailChange = (e) => {
    setError()
    setData({ ...data, email: e.target.value })
  }

  const handleFormPasswordChange = (e) => {
    setError()
    setData({ ...data, password: e.target.value })
  }

  const handleFormSubmit = async (e) => {
    e.preventDefault()

    try {
      setLoading(true)

      const res = await authenticateUser({
        variables: {
          input: data
        }
      })

      await apolloHelpers.onSignin(null, res.data.authenticateUser.token)
    } catch (err) {
      setError(err)
      setLoading(false)
    }
  }

  return (
    <AuthLayout>
      <div className='auth-signin-page'>
        <h1>
          Sign In
        </h1>
        {typeof error !== 'undefined' && (
          error.graphQLErrors && error.graphQLErrors.length ? (
            error.graphQLErrors.map((error, idx) => {
              return (
                <div key={idx} style={{ color: 'red' }}>
                  {error.message}
                </div>
              )
            })
          ) : (
            <div style={{ color: 'red' }}>
              {error.message}
            </div>
          )
        )}
        <form onSubmit={handleFormSubmit}>
          <div>
            <label>
              Email address
            </label>
            <input
              autoComplete='email'
              autoFocus
              disabled={loading}
              onChange={handleFormEmailChange}
              placeholder='Enter email'
              required
              type='email'
              value={data.email}
            />
          </div>
          <div>
            <label>
              Password
            </label>
            <input
              autoComplete='current-password'
              disabled={loading}
              onChange={handleFormPasswordChange}
              placeholder='Enter password'
              required
              type='password'
              value={data.password}
            />
          </div>
          <button
            disabled={typeof error !== 'undefined' || loading}
            type='submit'
          >
            Sign in
          </button>
        </form>
      </div>

      <style jsx>
        {`
          .auth-signin-page {
            position: relative;
          }
        `}
      </style>
    </AuthLayout>
  )
}

export default withGuest(AuthSigninPage)
