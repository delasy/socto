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
  await spawn('npx', ['sequelize-cli', 'db:migrate'], {
    env: {
      NODE_ENV: 'production'
    }
  })
}

exports.dev = async () => {
  await spawn('node', ['app.js'], {
    env: {
      NODE_ENV: 'development'
    }
  })
}

exports.start = async () => {
  await spawn('node', ['app.js'], {
    env: {
      NODE_ENV: 'production'
    }
  })
}

exports.test = async () => {
  await spawn('standard')
}
