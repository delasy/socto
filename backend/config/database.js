require('dotenv').config()

const initialConfig = {
  dialect: 'postgres',
  migrationStoragePath: 'sequelize',
  migrationStorageTableName: 'sequelize_migrations',

  define: {
    underscored: true
  }
}

module.exports = {
  development: {
    ...initialConfig,
    database: 'sct_dev',
    username: 'root',
    password: null,
    host: '127.0.0.1'
  },
  production: {
    ...initialConfig,
    dialectOptions: {
      keepAlive: true,
      ssl: {
        require: true,
        rejectUnauthorized: false
      }
    },
    logging: false,
    ssl: true,
    use_env_variable: 'DB_URL'
  },
  test: {
    ...initialConfig,
    database: 'sct_test',
    username: 'root',
    password: null,
    host: '127.0.0.1',
    logging: false,
    use_env_variable: 'DB_URL'
  }
}
