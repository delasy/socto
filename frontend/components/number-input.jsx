import React from 'react'
import PropTypes from 'prop-types'
import classnames from 'classnames'

const NumberInput = ({
  className: inheritClassName,
  onChange,
  value,
  ...props
}) => {
  const className = classnames(inheritClassName, 'number-input')

  const handleChange = (e) => {
    const newValue = Number.parseInt(e.target.value)
    onChange(newValue)
  }

  return (
    <div className={className}>
      <input
        onChange={handleChange}
        type='number'
        value={String(value)}
        {...props}
      />

      <style jsx>
        {`
          .number-input {
            position: relative;
          }
        `}
      </style>
    </div>
  )
}

NumberInput.defaultProps = {
  className: ''
}

NumberInput.propTypes = {
  className: PropTypes.string,
  onChange: PropTypes.func.isRequired,
  value: PropTypes.number.isRequired
}

export default NumberInput
