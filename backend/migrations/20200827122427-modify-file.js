module.exports = {
  up: async (queryInterface, Sequelize) => {
    const transaction = await queryInterface.sequelize.transaction()

    try {
      await Promise.all([
        queryInterface.addColumn('files', 'cache_ttl', {
          allowNull: false,
          defaultValue: 31536000,
          type: Sequelize.INTEGER
        }, { transaction })
      ])

      await Promise.all([
        queryInterface.changeColumn('files', 'cache_ttl', {
          allowNull: false,
          type: Sequelize.INTEGER
        }, { transaction })
      ])

      await transaction.commit()
    } catch (err) {
      await transaction.rollback()
      throw err
    }
  },
  down: async (queryInterface) => {
    return queryInterface.removeColumn('files', 'cache_ttl')
  }
}
