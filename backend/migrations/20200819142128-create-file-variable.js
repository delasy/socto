module.exports = {
  up: async (queryInterface, Sequelize) => {
    const transaction = await queryInterface.sequelize.transaction()

    try {
      await queryInterface.createTable('file_variables', {
        id: {
          allowNull: false,
          primaryKey: true,
          type: Sequelize.UUID
        },
        file_id: {
          allowNull: false,
          onUpdate: 'CASCADE',
          onDelete: 'CASCADE',
          references: {
            model: 'files',
            key: 'id'
          },
          type: Sequelize.UUID
        },
        variable_id: {
          allowNull: false,
          onUpdate: 'CASCADE',
          onDelete: 'CASCADE',
          references: {
            model: 'variables',
            key: 'id'
          },
          type: Sequelize.UUID
        },
        value: {
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

      await queryInterface.addConstraint('file_variables', {
        fields: ['file_id', 'variable_id', 'deleted_at'],
        name: 'file_variables_file_id_variable_id_deleted_at_ukey',
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
    return queryInterface.dropTable('file_variables')
  }
}
