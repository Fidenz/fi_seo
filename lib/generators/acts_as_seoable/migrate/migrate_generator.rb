
require 'rails/generators'
require 'rails/generators/migration'

module ActsAsSeoable
  module Generators
    class MigrateGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      def self.next_migration_number(path)
        next_migration_number = current_migration_number(path) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end

      def copy_migrations
        migration_template 'migration.erb',
                           'db/migrate/create_seo_tables.rb', migration_version: migration_version
      end

      private

      def migration_version
        if rails5?
          '[4.2]'
        elsif rails6?
          '[6.0]'
        end
      end

      def rails5?
        Rails.version.start_with? '5'
      end

      def rails6?
        Rails.version.start_with? '6'
      end
    end
  end
end
