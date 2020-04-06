
require 'rails/generators'

module ActsAsSeoable
  module Generators
    class AdminViewHelperGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def generate_config_file
        template '_view_helper.html.arb', 'app/views/acts_as_seoable/_view_helper.html.arb'
      end
    end
  end
end
