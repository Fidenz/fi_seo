require 'rails/generators'

module ActsAsSeoable
  module Generators
    class AdminGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def generate_config_file
        template 'admin.rb', 'app/admin/acts_as_seoable.rb'
      end
    end
  end
end
