require 'acts_as_seoable/static_seo'
require 'meta-tags'

module ActsAsSeoableStaticClassMethods

  def create_static_seo_records
    Rails.application.reload_routes!
    routes = Rails.application.routes.routes.select { |r| r.defaults.include? :acts_as_seoable }
    row_routes = Array.new

    routes.each do |route|
      row = StaticSeo.find_by_seoable_controller_and_seoable_action(route.defaults[:controller], route.defaults[:action])
      status = route.defaults[:acts_as_seoable] == true
      if row.nil?
        new_row = StaticSeo.create(seoable_controller: route.defaults[:controller], seoable_action: route.defaults[:action],
                         title: '', description: '', keywords: '', status: status)
        row_routes << new_row
      else
        row_routes << row
        row.update(status: status)
      end
    end

    StaticSeo.all.each do |static_seo|
      next if row_routes.include? static_seo

      static_seo.delete
    end
  end

  def create_static_meta_tags(controller_name, action_name, _options = {})
    FiSeo::create_static_seo_records

    configuration = { reverse: false,
                      lowercase: false,
                      index: false,
                      noindex: false,
                      nofollow: false,
                      follow: false,
                      noarchive: false,
                      separator: '&#124;',
                      canonical: false,
                      canonical_url: '' }
    configuration.update(_options) if _options.present?
    row = StaticSeo.find_by_seoable_controller_and_seoable_action(controller_name, action_name)
    hash = if row.nil? || (row && row.status == false)
             {
               title: '',
               description: '',
               keywords: ''
             }
           else
             static_hash = {
               title: row.title,
               description: row.description,
               keywords: row.keywords,
               lowercase: configuration[:lowercase],
               reverse: configuration[:reverse],
               index: configuration[:index],
               noindex: configuration[:noindex],
               follow: configuration[:follow],
               nofollow: configuration[:nofollow],
               noarchive: configuration[:noarchive],
               separator: configuration[:separator].html_safe
             }
             if configuration[:canonical].present?
               static_hash.merge!(canonical: configuration[:canonical_url])
             end
             static_hash
           end
    hash
  end
end
