require 'xml-sitemap'
require 'acts_as_seoable/helpers/sitemap_helper'

class SitemapController < ApplicationController
  extend ActionDispatch::Routing::UrlFor

  def sitemap
    FiSeo::create_sitemap_seo_records
    class_names = ActiveRecord::Base.connection.tables.map do |model|
      model
    end

    @map = XmlSitemap::Map.new('ravel.com') do |m|
      SitemapSeo.all.each do |site_map_seo|
        action = site_map_seo.sitemap_action
        controller = site_map_seo.sitemap_controller

        if class_names.include? controller
          p = controller.capitalize.singularize.camelize
          if Object.const_defined?(p) && (%w[destroy update create index new].exclude? action)
            p.constantize.all.each do |record|
              if controller != 'host' && (%w[new create index].include? action)
                m.add(url_for(controller: controller, action: action, only_path: true),
                      priority: 0.2, updated: Date.today, period: :never)
              elsif controller != 'host'
                m.add(url_for(controller: controller, action: action, id: record.id, only_path: true),
                      priority: 0.2, updated: Date.today, period: :never)
              end
            end
          elsif controller != 'host' && (%w[destroy update create].exclude? action)
            m.add(url_for(controller: controller, action: action, only_path: true),
                  priority: 0.2, updated: Date.today, period: :never)
          end
        end
      end
    end

    respond_to do |format|
      format.xml
    end
  end
end