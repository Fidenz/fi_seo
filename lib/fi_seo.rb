# frozen_string_literal: true

require 'meta-tags'
require 'xml-sitemap'

require 'acts_as_seoable/version'
require 'active_record'
require 'active_record/version'
require 'active_support/core_ext/module'
require 'active_support/core_ext/hash'
require 'generators/acts_as_seoable/migrate/migrate_generator'
require 'acts_as_seoable/dynamic_seo'
require 'acts_as_seoable/static_seo'
require 'acts_as_seoable/google_analytic_seo'
require 'acts_as_seoable/sitemap_seo'
require 'acts_as_seoable/engine'
require 'acts_as_seoable/helpers/static_helper'
require 'acts_as_seoable/helpers/sitemap_helper'

module FiSeo
  extend ActiveSupport::Concern
  extend SitemapClassMethods
  extend ActsAsSeoableStaticClassMethods

  class << self
    attr_accessor :initialized_config
  end

  def self.initialized_config
    @initialized_config ||= Configuration.new
  end

  def self.configure
    yield(initialized_config)
  end

  class Configuration
    attr_accessor :default_facebook_title
    attr_accessor :default_facebook_url
    attr_accessor :default_facebook_type
    attr_accessor :default_facebook_image
    attr_accessor :default_facebook_description
    attr_accessor :default_twitter_title
    attr_accessor :default_twitter_card
    attr_accessor :default_twitter_site
    attr_accessor :default_twitter_image
    attr_accessor :default_twitter_description
    attr_accessor :default_canonical_url
    attr_accessor :sitemap_host_url
    attr_accessor :sitemap_enable

    def initialize
      @default_facebook_title = ''
      @default_facebook_url = ''
      @default_facebook_type = ''
      @default_facebook_image = ''
      @default_facebook_description = ''
      @default_twitter_title = ''
      @default_twitter_card = ''
      @default_twitter_site = ''
      @default_twitter_image = ''
      @default_twitter_description = ''
      @default_canonical_url = ''
      @sitemap_host_url = 'www.domain.com'
      @sitemap_enable = true

    end
  end

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
                        social: false,
                        separator: '&#124;',
                        canonical: false }
      configuration.update(_options) if _options.present?
      configuration[:fields] = attr_names.flatten.uniq.compact

      class_attribute :seoable_options
      self.seoable_options = configuration

      self.send('after_create', :create_dynamic_seo_record)
      self.send('after_update', :update_dynamic_seo_record)
      self.send('has_one', :dynamic_seo, as: :seoable, dependent: :delete)
      self.send('accepts_nested_attributes_for', :dynamic_seo)
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

    def to_meta_tags
      row = DynamicSeo.find_by_seoable_type_and_seoable_id(self.class.to_s, self.id)
      if row.nil?
        {}
      else
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
          noarchive: self.class.seoable_options[:noarchive],
          separator: self.class.seoable_options[:separator].html_safe
        }

        if self.class.seoable_options[:social].present?
          if self.class.seoable_options[:social].include? :facebook
            hash.merge!(og: facebook_tags)
          end
          if self.class.seoable_options[:social].include? :twitter
            hash.merge!(twitter: twitter_tags)
          end
        end
        if self.class.seoable_options[:canonical].present?
          hash.merge!(canonical: canonical_url)
        end
        hash
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
        title: FiSeo.initialized_config.default_facebook_title,
        type: FiSeo.initialized_config.default_facebook_type,
        url: FiSeo.initialized_config.default_facebook_url,
        image: FiSeo.initialized_config.default_facebook_image,
        description: FiSeo.initialized_config.default_facebook_description
      }
    end

    def twitter_tags
      {
        title: FiSeo.initialized_config.default_twitter_title,
        card: FiSeo.initialized_config.default_twitter_card,
        site: FiSeo.initialized_config.default_twitter_site,
        image: FiSeo.initialized_config.default_twitter_image,
        description: FiSeo.initialized_config.default_twitter_description
      }
    end

    def canonical_url
      FiSeo.initialized_config.default_canonical_url
    end

    def title_value
      if self&.dynamic_seo&.title
        self.dynamic_seo.title
      else
        self.send(self.class.seoable_fields.first) || ''
      end
    end

    def description_value
      if self&.dynamic_seo&.description
        self.dynamic_seo.description
      else
        self.send(self.class.seoable_fields.second) || ''
      end
    end

    def keywords_value
      if self&.dynamic_seo&.keywords
        self.dynamic_seo.keywords
      else
        self.send(self.class.seoable_fields.third) || ''
      end
    end
  end
end

ActiveRecord::Base.send(:include, FiSeo)