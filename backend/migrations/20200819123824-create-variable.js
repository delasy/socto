module.exports = {
  up: async (queryInterface, Sequelize) => {
    const transaction = await queryInterface.sequelize.transaction()

    try {
      await queryInterface.createTable('variables', {
        id: {
          allowNull: false,
          primaryKey: true,
          type: Sequelize.UUID
        },
        project_id: {
          allowNull: false,
          onUpdate: 'CASCADE',
          onDelete: 'CASCADE',
          references: {
            model: 'projects',
            key: 'id'
          },
          type: Sequelize.UUID
        },
        name: {
          allowNull: false,
          type: Sequelize.STRING
        },
        created_at: {
          allowNull: false,
          type: Sequelize.DATE
        },
        deleted_at: {
          allowNull: true,
          type: Sequelize.DATE
        },
        updated_at: {
          allowNull: false,
          type: Sequelize.DATE
        }
      }, { transaction })

      await queryInterface.addConstraint('variables', {
        fields: ['project_id', 'name', 'deleted_at'],
        name: 'variables_project_id_name_deleted_at_ukey',
        transaction: transaction,
        type: 'unique'
      })

      await transaction.commit()
    } catch (err) {
      await transaction.rollback()
      throw err
    }
  },
  down: (queryInterface) => {
    return queryInterface.dropTable('variables')
  }
}
