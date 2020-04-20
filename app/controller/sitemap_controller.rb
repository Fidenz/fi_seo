require 'xml-sitemap'
require 'acts_as_seoable/helpers/sitemap_helper'

class SitemapController < ApplicationController
  extend ActionDispatch::Routing::UrlFor

  def sitemap
    FiSeo::create_sitemap_seo_records
    class_names = ActiveRecord::Base.connection.tables.map do |model|
      model
    end

    domain = 'www.domain.com'
    domain = FiSeo.initialized_config.sitemap_host_url if FiSeo.initialized_config.sitemap_host_url.present?

    @map = XmlSitemap::Map.new(domain) do |m|
      SitemapSeo.where(status: true).each do |site_map_seo|
        action = site_map_seo.sitemap_action
        controller = site_map_seo.sitemap_controller
        priority = site_map_seo.priority
        period = site_map_seo.period
        static = site_map_seo.static

        if SitemapSeo.periods[period.to_sym] == 0
          period_string = 'none'
          period_sym = period_string.to_sym
        else
          period_sym = period.to_sym
        end

        if class_names.include? controller.pluralize
          p = controller.capitalize.singularize.camelize
          if Object.const_defined?(p) && (%w[destroy update create index new].exclude? action) && p.constantize.any?
            p.constantize.all.each do |record|
              if (%w[new create index].include? action) || static
                m.add(url_for(controller: controller, action: action, only_path: true),
                      priority: priority, updated: Date.today, period: period_sym)
              else
                m.add(url_for(controller: controller, action: action, id: record.id, only_path: true),
                      priority: priority, updated: Date.today, period: period_sym)
              end
            end
          elsif %w[destroy update create].exclude? action
            m.add(url_for(controller: controller, action: action, only_path: true),
                  priority: priority, updated: Date.today, period: period_sym)
          end
        elsif %w[destroy update create].exclude? action
          m.add(url_for(controller: controller, action: action, only_path: true),
                priority: priority, updated: Date.today, period: period_sym)
        end
      end
    end

    respond_to do |format|
      format.xml
    end
  end
end