require 'rails/generators'

module ActsAsSeoable
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def copy_initializer_file
        copy_file 'initializer.rb', 'config/initializers/acts_as_seoable.rb'
      end
    end
  end
end
