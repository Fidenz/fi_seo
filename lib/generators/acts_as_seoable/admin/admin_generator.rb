require 'rails/generators'

module ActsAsSeoable
  module Generators
    class AdminGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def generate_config_file
        if Gem.loaded_specs.has_key?('activeadmin')
          template 'admin.rb', 'app/admin/acts_as_seoable.rb'
        else
          raise StandardError, "Could not generate activeadmin page without activeadmin installed."
        end
      end
    end
  end
end
