module.exports = {
  up: async (queryInterface, Sequelize) => {
    const transaction = await queryInterface.sequelize.transaction()

    try {
      await queryInterface.createTable('layouts', {
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
        body_code: {
          allowNull: false,
          type: Sequelize.TEXT
        },
        head_code: {
          allowNull: false,
          type: Sequelize.TEXT
        },
        scripts: {
          allowNull: false,
          type: Sequelize.TEXT
        },
        styles: {
          allowNull: false,
          type: Sequelize.TEXT
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

      await queryInterface.addConstraint('layouts', {
        fields: ['project_id', 'name', 'deleted_at'],
        name: 'layouts_project_id_name_deleted_at_ukey',
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
    return queryInterface.dropTable('layouts')
  }
}
