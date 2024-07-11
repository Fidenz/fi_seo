require 'acts_as_seoable/sitemap_seo'

module SitemapClassMethods

  def create_sitemap_seo_records
    Rails.application.reload_routes!
    routes = Rails.application.routes.routes.select { |r| r.defaults.include? :sitemap}
    row_routes = Array.new

    routes.each do |route|
      next if route.defaults[:sitemap] != true || route.verb != 'GET'
      
      static = route.defaults[:static] == true
      row = SitemapSeo.find_by_sitemap_controller_and_sitemap_action(route.defaults[:controller], route.defaults[:action])

      if row.nil?
        byebug
        new_row = SitemapSeo.create(sitemap_controller: route.defaults[:controller], sitemap_action: route.defaults[:action],
                                    status: false, static: static, route_path: route.path.spec.to_s)

        route.path.spec.to_s
        row_routes << new_row
      else
        byebug
        row.update(static: static, route_path: route.path.spec.to_s)
        row.save
        row_routes << row
      end
    end

    SitemapSeo.where(static: true).all.each do |sitemap_seo|
      next if row_routes.include? sitemap_seo

      sitemap_seo.delete
    end
  end
end
