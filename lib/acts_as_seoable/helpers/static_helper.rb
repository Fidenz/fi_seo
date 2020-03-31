require 'acts_as_seoable/static_seo'
require 'meta-tags'

module StaticRoutes

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

  def create_static_meta_tags(controller_name, action_name)
    FiSeo::create_static_seo_records
    row = StaticSeo.find_by_seoable_controller_and_seoable_action(controller_name, action_name)
    hash = if row.nil? || (row && row.status == false)
             {
               title: '',
               description: '',
               keywords: ''
             }
           else
             {
               title: row.title,
               description: row.description,
               keywords: row.keywords
             }
           end
    hash
  end
end
