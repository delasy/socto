module.exports = {
  up: async (queryInterface, Sequelize) => {
    const transaction = await queryInterface.sequelize.transaction()

    try {
      await Promise.all([
        queryInterface.addColumn('pages', 'published_at', {
          allowNull: true,
          defaultValue: Sequelize.fn('NOW'),
          type: Sequelize.DATE
        }, { transaction })
      ])

      await Promise.all([
        queryInterface.changeColumn('pages', 'published_at', {
          allowNull: true,
          type: Sequelize.DATE
        }, { transaction })
      ])

      await transaction.commit()
    } catch (err) {
      await transaction.rollback()
      throw err
    }
  },
  down: async (queryInterface) => {
    return queryInterface.removeColumn('pages', 'published_at')
  }
}
