Rails.application.routes.draw do
  get 'sitemap' => 'sitemap#sitemap', format: true
end
