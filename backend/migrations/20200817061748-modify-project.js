module.exports = {
  up: async (queryInterface, Sequelize) => {
    const transaction = await queryInterface.sequelize.transaction()

    try {
      await Promise.all([
        queryInterface.renameColumn('projects', 'domain', 'public_url', {
          transaction
        }),
        queryInterface.addColumn('projects', 'provider', {
          allowNull: false,
          defaultValue: 'AWS',
          type: Sequelize.ENUM('AWS')
        }, { transaction }),
        queryInterface.addColumn('projects', 'config_aws', {
          allowNull: true,
          type: Sequelize.JSONB
        }, { transaction })
      ])

      await queryInterface.sequelize.query(
        'ALTER TABLE projects ALTER COLUMN provider DROP DEFAULT;',
        { transaction }
      )

      await transaction.commit()
    } catch (err) {
      await transaction.rollback()
      throw err
    }
  },
  down: async (queryInterface) => {
    const transaction = await queryInterface.sequelize.transaction()

    try {
      await Promise.all([
        queryInterface.renameColumn('projects', 'public_url', 'domain', {
          transaction
        }),
        queryInterface.removeColumn('projects', 'config_aws', {
          transaction
        }),
        queryInterface.removeColumn('projects', 'provider', {
          transaction
        })
      ])

      await queryInterface.sequelize.query(
        'DROP TYPE enum_projects_provider;',
        { transaction: transaction }
      )

      await transaction.commit()
    } catch (err) {
      await transaction.rollback()
      throw err
    }
  }
}
