# frozen_string_literal: true

require 'fi_seo/version'
require 'active_record'
require 'active_record/version'
require 'active_support/core_ext/module'
require 'generators/act_as_seoable/migrate/migrate_generator'

module FiSeo
  extend ActiveSupport::Concern

  module ClassMethods

    # def act_as_seoable(*attr_fields)
    #   extend  FiSeoClassMethods
    #   include FiSeoInstanceMethods
    #
    #   class_attribute :title
    #   self.title = title
    #   class_attribute :description
    #   self.description = description
    #   class_attribute :keywords
    #   self.description = keywords
    # end
  end

  module FiSeoClassMethods

  end

  module FiSeoInstanceMethods

    # def create_dynamic_seo_record
    #   DynamicSeo.create(seoable_type: self.class.to_s, seoable_id: self.id, title: self.class.title,
    #                     description: self.class.description, keywords: self.class.keywords )
    # end
  end
end
