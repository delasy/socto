module.exports = {
  up: async (queryInterface, Sequelize) => {
    const transaction = await queryInterface.sequelize.transaction()

    try {
      await Promise.all([
        queryInterface.addColumn('projects', 'global_body_code', {
          allowNull: false,
          defaultValue: '{{ LAYOUT_CONTENT }}',
          type: Sequelize.TEXT
        }, { transaction }),
        queryInterface.addColumn('projects', 'global_head_code', {
          allowNull: false,
          defaultValue: '',
          type: Sequelize.TEXT
        }, { transaction }),
        queryInterface.addColumn('projects', 'global_scripts', {
          allowNull: false,
          defaultValue: '',
          type: Sequelize.TEXT
        }, { transaction }),
        queryInterface.addColumn('projects', 'global_styles', {
          allowNull: false,
          defaultValue: '',
          type: Sequelize.TEXT
        }, { transaction }),
        queryInterface.addColumn('projects', 'global_variables', {
          allowNull: false,
          defaultValue: {},
          type: Sequelize.JSONB
        }, { transaction })
      ])

      await Promise.all([
        queryInterface.changeColumn('projects', 'global_body_code', {
          allowNull: false,
          type: Sequelize.TEXT
        }, { transaction }),
        queryInterface.changeColumn('projects', 'global_head_code', {
          allowNull: false,
          type: Sequelize.TEXT
        }, { transaction }),
        queryInterface.changeColumn('projects', 'global_scripts', {
          allowNull: false,
          type: Sequelize.TEXT
        }, { transaction }),
        queryInterface.changeColumn('projects', 'global_styles', {
          allowNull: false,
          type: Sequelize.TEXT
        }, { transaction }),
        queryInterface.changeColumn('projects', 'global_variables', {
          allowNull: false,
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
        queryInterface.removeColumn('projects', 'global_body_code', {
          transaction
        }),
        queryInterface.removeColumn('projects', 'global_head_code', {
          transaction
        }),
        queryInterface.removeColumn('projects', 'global_scripts', {
          transaction
        }),
        queryInterface.removeColumn('projects', 'global_styles', {
          transaction
        }),
        queryInterface.removeColumn('projects', 'global_variables', {
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
