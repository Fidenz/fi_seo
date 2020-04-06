Rails.application.routes.draw do
  sitemap_enable = false
  sitemap_enable = true if FiSeo.initialized_config.sitemap_enable == true
  if sitemap_enable
    get 'sitemap' => 'sitemap#sitemap', format: true
  end
end
