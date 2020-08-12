module.exports = {
  up: async (queryInterface, Sequelize) => {
    const transaction = await queryInterface.sequelize.transaction()

    try {
      await Promise.all([
        queryInterface.addColumn('projects', 'description', {
          allowNull: false,
          defaultValue: '',
          type: Sequelize.STRING
        }, { transaction }),
        queryInterface.addColumn('projects', 'theme_color', {
          allowNull: false,
          defaultValue: '',
          type: Sequelize.STRING
        }, { transaction })
      ])

      await Promise.all([
        queryInterface.changeColumn('projects', 'description', {
          allowNull: false,
          type: Sequelize.STRING
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
  },
  down: async (queryInterface) => {
    const transaction = await queryInterface.sequelize.transaction()

    try {
      await Promise.all([
        queryInterface.removeColumn('projects', 'description', {
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
  }
}
