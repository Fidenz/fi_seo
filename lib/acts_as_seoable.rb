# frozen_string_literal: true

require 'acts_as_seoable/version'
require 'active_record'
require 'active_record/version'
require 'active_support/core_ext/module'
require 'generators/acts_as_seoable/migrate/migrate_generator'
require 'acts_as_seoable/dynamic_seo'

module ActAsSeoable
  extend ActiveSupport::Concern

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    def acts_as_seoable(*attr_fields)
      extend  ActsAsSeoableClassMethods
      include ActsAsSeoableInstanceMethods

      class_attribute :title
      self.title = title
      class_attribute :description
      self.description = description
      class_attribute :keywords
      self.description = keywords

      send('after_create', :create_dynamic_seo_record)
      send('after_update', :update_dynamic_seo_record)
      send('has_one', :dynamic_seo, as: :seoable, dependent: :delete)
    end
  end

  module ActsAsSeoableClassMethods

  end

  module ActsAsSeoableInstanceMethods

    def create_dynamic_seo_record
      DynamicSeo.create(seoable_type: self.class.to_s, seoable_id: id, title: self.class.title,
                        description: self.class.description, keywords: self.class.keywords)
    end
  end
end

ActiveRecord::Base.send :include, ActsAsSeoable