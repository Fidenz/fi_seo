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

    def acts_as_seoable(title, description, keywords, _options = {})
      extend  ActsAsSeoableClassMethods
      include ActsAsSeoableInstanceMethods

      attr_names = [title, description, keywords]
      configuration = { check_for_changes: true,
                        reverse: false,
                        lowercase: false,
                        index: false,
                        noindex: false,
                        nofollow: false,
                        follow: false,
                        noarchive: false,
                        social: false }
      configuration.update(_options) if _options.present?
      configuration[:fields] = attr_names.flatten.uniq.compact

      class_attribute :seoable_options
      self.seoable_options = configuration

      self.send('after_create', :create_dynamic_seo_record)
      self.send('after_update', :update_dynamic_seo_record)
      self.send('has_one', :dynamic_seo, as: :seoable, dependent: :delete)
    end
  end

  def self.included(receiver)
    receiver.extend(ClassMethods)
  end

  module ActsAsSeoableClassMethods

    def seoable_fields
      self.seoable_options[:fields]
    end
  end

  module ActsAsSeoableInstanceMethods

    def to_meta_tags(_params = {})
      row = DynamicSeo.find_by_seoable_type_and_seoable_id(self.class.to_s, self.id)
      unless row.nil?
        hash = {
          title: row.title,
          description: row.description,
          keywords: row.keywords,
          lowercase: self.class.seoable_options[:lowercase],
          reverse: self.class.seoable_options[:reverse],
          index: self.class.seoable_options[:index],
          noindex: self.class.seoable_options[:noindex],
          follow: self.class.seoable_options[:follow],
          nofollow: self.class.seoable_options[:nofollow],
          noarchive: self.class.seoable_options[:noarchive]
        }

        if self.class.seoable_options[:social].present?
          if self.class.seoable_options[:social].include? :facebook
            hash.merge!(og: facebook_tags)
          end
          if self.class.seoable_options[:social].include? :twitter
            hash.merge!(twitter: twitter_tags)
          end
        end
        return hash
      end
    end



    def create_dynamic_seo_record
      DynamicSeo.create(seoable_type: self.class.to_s, seoable_id: id, title: self.title_value,
                        description: self.description_value, keywords: self.keywords_value)
    end

    def update_dynamic_seo_record
      if self.class.seoable_options[:check_for_changes]
        row = DynamicSeo.find_by_seoable_type_and_seoable_id(self.class.to_s, self.id)
        if row.nil?
          self.create_dynamic_seo_record
        else
          DynamicSeo.where(seoable_type: self.class.to_s).where(seoable_id: self.id)
                    .update_all(title: self.title_value, description: self.description_value, keywords: self.keywords_value)
        end
      end
    end

    def facebook_tags
      {
        title: '',
        type: '',
        url: '',
        image: ''
      }
    end

    def twitter_tags
      {
        card: '',
        site: ''
      }
    end

    def title_value
      self.send(self.class.seoable_fields.first)
    end

    def description_value
      self.send(self.class.seoable_fields.second)
    end

    def keywords_value
      self.send(self.class.seoable_fields.third)
    end
  end
end

ActiveRecord::Base.send(:include, FiSeo)