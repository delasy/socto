module.exports = {
  up: async (queryInterface) => {
    return queryInterface.removeColumn('pages', 'structured_data')
  },
  down: async (queryInterface, Sequelize) => {
    const transaction = await queryInterface.sequelize.transaction()

    try {
      await Promise.all([
        queryInterface.addColumn('pages', 'structured_data', {
          allowNull: false,
          defaultValue: '',
          type: Sequelize.TEXT
        }, { transaction })
      ])

      await Promise.all([
        queryInterface.changeColumn('pages', 'structured_data', {
          allowNull: false,
          type: Sequelize.TEXT
        }, { transaction })
      ])

      await transaction.commit()
    } catch (err) {
      await transaction.rollback()
      throw err
    }
  }
}
