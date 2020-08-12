module.exports = {
  up: async (queryInterface, Sequelize) => {
    const transaction = await queryInterface.sequelize.transaction()

    try {
      await Promise.all([
        queryInterface.addColumn('assets', 'mime_type', {
          allowNull: false,
          defaultValue: '',
          type: Sequelize.STRING
        }, { transaction })
      ])

      await Promise.all([
        queryInterface.changeColumn('assets', 'mime_type', {
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
    return queryInterface.removeColumn('assets', 'mime_type')
  }
}
