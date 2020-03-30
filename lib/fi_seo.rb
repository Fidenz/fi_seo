# frozen_string_literal: true

require 'acts_as_seoable/version'
require 'active_record'
require 'active_record/version'
require 'active_support/core_ext/module'
require 'generators/acts_as_seoable/migrate/migrate_generator'
require 'acts_as_seoable/dynamic_seo'

module FiSeo
  extend ActiveSupport::Concern

  module ClassMethods

    def acts_as_seoable(title, description, keywords)
      extend  ActsAsSeoableClassMethods
      include ActsAsSeoableInstanceMethods

      class_attribute :seoable_title
      class_attribute :seoable_description
      class_attribute :seoable_keywords

      self.seoable_title = title
      self.seoable_description = description
      self.seoable_keywords = keywords

      self.send('after_create', :create_dynamic_seo_record)
      self.send('after_update', :update_dynamic_seo_record)
      self.send('has_one', :dynamic_seo, as: :seoable, dependent: :delete)
    end
  end

  def self.included(receiver)
    receiver.extend(ClassMethods)
  end

  module ActsAsSeoableClassMethods

    def seoable_title
      seoable_title
    end

    def seoable_description
      seoable_description
    end

    def seoable_keywords
      seoable_keywords
    end
  end

  module ActsAsSeoableInstanceMethods

    def create_dynamic_seo_record
      DynamicSeo.create(seoable_type: self.class.to_s, seoable_id: id, title: self.seoable_title,
                        description: self.seoable_description, keywords: self.seoable_keywords)
    end

    def update_dynamic_seo_record
      if self.seoable_title.present?
        row = DynamicSeo.find_by_seoable_type_and_seoable_id(self.class.to_s, self.id)
        if row.nil?
          self.create_dynamic_seo_record
        else
          DynamicSeo.where(seoable_type: self.class.to_s).where(seoable_id: self.id)
                    .update_all(title: self.seoable_title, description: self.seoable_description, keywords: self.seoable_keywords)
        end
      else
        row = DynamicSeo.find_by_seoable_type_and_seoable_id(self.class.to_s, self.id)
        row&.destroy
      end
    end
  end
end

ActiveRecord::Base.send(:include, FiSeo)