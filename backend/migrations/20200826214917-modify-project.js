module.exports = {
  up: async (queryInterface, Sequelize) => {
    const transaction = await queryInterface.sequelize.transaction()

    try {
      await Promise.all([
        queryInterface.renameColumn(
          'projects',
          'provider',
          'bucket_provider',
          { transaction }
        ),
        queryInterface.renameColumn(
          'projects',
          'config_aws',
          'bucket_config_aws',
          { transaction }
        ),
        queryInterface.addColumn('projects', 'cdn_provider', {
          allowNull: true,
          type: Sequelize.ENUM('CLOUDFLARE')
        }, { transaction }),
        queryInterface.addColumn('projects', 'cdn_config_cloudflare', {
          allowNull: true,
          type: Sequelize.JSONB
        }, { transaction })
      ])

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
        queryInterface.renameColumn(
          'projects',
          'bucket_provider',
          'provider',
          { transaction }
        ),
        queryInterface.renameColumn(
          'projects',
          'bucket_config_aws',
          'config_aws',
          { transaction }
        ),
        queryInterface.removeColumn(
          'projects',
          'cdn_provider',
          { transaction }
        ),
        queryInterface.removeColumn(
          'projects',
          'cdn_config_cloudflare',
          { transaction }
        )
      ])

      await queryInterface.sequelize.query(
        'DROP TYPE enum_projects_cdn_provider;',
        { transaction: transaction }
      )

      await transaction.commit()
    } catch (err) {
      await transaction.rollback()
      throw err
    }
  }
}
