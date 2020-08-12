module.exports = {
  up: async (queryInterface) => {
    const transaction = await queryInterface.sequelize.transaction()

    try {
      await Promise.all([
        queryInterface.removeColumn('projects', 'global_variables', {
          transaction
        }),
        queryInterface.removeColumn('projects', 'theme_color', {
          transaction
        })
      ])

      await transaction.commit()
    } catch (err) {
      await transaction.rollback()
      throw err
    }
  },
  down: async (queryInterface, Sequelize) => {
    const transaction = await queryInterface.sequelize.transaction()

    try {
      await Promise.all([
        queryInterface.addColumn('projects', 'global_variables', {
          allowNull: false,
          defaultValue: {},
          type: Sequelize.JSONB
        }, { transaction }),
        queryInterface.addColumn('projects', 'theme_color', {
          allowNull: false,
          defaultValue: '',
          type: Sequelize.STRING
        }, { transaction })
      ])

      await Promise.all([
        queryInterface.changeColumn('projects', 'global_variables', {
          allowNull: false,
          type: Sequelize.JSONB
        }, { transaction }),
        queryInterface.changeColumn('projects', 'theme_color', {
          allowNull: false,
          type: Sequelize.STRING
        }, { transaction })
      ])

      await transaction.commit()
    } catch (err) {
      await transaction.rollback()
      throw err
    }
  }
}
