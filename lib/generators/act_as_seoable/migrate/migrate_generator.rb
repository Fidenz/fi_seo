
require 'rails/generators'
require 'rails/generators/migration'

module ActAsSeoable
  module Generators
    class MigrateGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)
      
      def self.next_migration_number(path)
        next_migration_number = current_migration_number(path) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end
      
      def copy_migrations
        migration_template "migration.rb",
                           "db/migrate/create_double_double.rb"
      end
    end
  end
end
