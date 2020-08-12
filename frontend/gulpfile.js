require('dotenv').config()

const _ = require('lodash')
const spawnCommand = require('child_process').spawn

const spawn = (cmd, args = [], opts = {}) => {
  const child = spawnCommand(cmd, args, _.merge({
    env: {
      ...process.env,
      FORCE_COLOR: '1'
    },
    stdio: 'pipe'
  }, opts))

  child.stderr.pipe(process.stderr)
  child.stdout.pipe(process.stdout)

  return new Promise((resolve, reject) => {
    child.on('close', (code) => {
      if (code === null) {
        process.exit(1)
      } else {
        code === 0 ? resolve() : process.exit(code)
      }
    })

    child.on('error', (err) => {
      reject(err)
    })
  })
}

exports.build = async () => {
  await spawn('next', ['build'])
}

exports.dev = async () => {
  await spawn('next', ['-p', process.env.PORT || '8080'])
}

exports.start = async () => {
  await spawn('next', ['start', '-p', process.env.PORT || '8080'])
}

exports.test = async () => {
  await spawn('standard')
}
