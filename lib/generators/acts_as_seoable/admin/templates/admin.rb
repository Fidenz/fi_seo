
ActiveAdmin.register_page 'SEOData' do
  menu label: 'SEO Data', url: '#'
end

ActiveAdmin.register StaticSeo do
  menu label: 'Static Pages', priority: 1, parent: 'SEOData'
  config.filters = false
  actions :all, except: %i[destroy new]

  show title: proc { |static_seo| "#{static_seo.seoable_controller.titleize} - #{static_seo.seoable_action.titleize}" } do
    attributes_table do
      row('Controller', &:seoable_controller)
      row('Action', &:seoable_action)
      row :title
      row :description
      row :keywords
      row :status
      row :facebook_title
      row :facebook_url
      row :facebook_type
      row :facebook_image
      row :facebook_description
      row :twitter_title
      row :twitter_card
      row :twitter_site
      row :twitter_image
      row :twitter_description
      row :created_at
      row :updated_at
    end
  end

  index title: 'Static SEO' do
    column 'Controller' do |static_seo|
      static_seo.seoable_controller.titleize
    end
    column 'Action' do |static_seo|
      static_seo.seoable_action.titleize
    end
    column :title
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :seoable_controller, input_html: { readonly: true }
      f.input :seoable_action, input_html: { readonly: true }
      f.input :title
      f.input :description
      f.input :keywords
      f.input :status
      f.input :facebook_title
      f.input :facebook_url
      f.input :facebook_type
      f.input :facebook_image
      f.input :facebook_description
      f.input :twitter_title
      f.input :twitter_card
      f.input :twitter_site
      f.input :twitter_image
      f.input :twitter_description
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end

ActiveAdmin.register DynamicSeo do
  menu label: 'Dynamic Pages', priority: 2, parent: 'SEOData'
  config.filters = false
  actions :all, except: %i[destroy new edit]

  show do
    attributes_table do
      row('Type', &:seoable_type)
      row('Id', &:seoable_id)
      row :created_at
      row :updated_at
    end
  end

  index title: 'Dynamic SEO' do
    column 'Type' do |dynamic_seo|
      dynamic_seo.seoable_type.titleize
    end
    column 'Id' do |dynamic_seo|
      dynamic_seo.seoable_id
    end
    column :created_at
    column :updated_at
    actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end

ActiveAdmin.register SitemapSeo do
  menu label: 'Sitemap Seo', priority: 3, parent: 'SEOData'
  config.filters = false
  actions :all, except: %i[destroy new]

  show title: proc { |sitemap_seo| "#{sitemap_seo.sitemap_controller.titleize} - #{sitemap_seo.sitemap_action.titleize}" } do
    attributes_table do
      row('Controller', &:sitemap_controller)
      row('Action', &:sitemap_action)
      row :priority
      row 'Period' do |sitemap_seo|
        sitemap_seo.period.titleize
      end
      row :status
      row :created_at
      row :updated_at
    end
  end

  batch_action :active do |ids|
    batch_action_collection.find(ids).each do |sitemap_seo|
      sitemap_seo.update status: true
    end
    redirect_to collection_path, alert: 'The sitemap seos have been activated.'
  end

  batch_action :inactive do |ids|
    batch_action_collection.find(ids).each do |sitemap_seo|
      sitemap_seo.update status: false
    end
    redirect_to collection_path, alert: 'The sitemap seos have been deactivated.'
  end

  index title: 'Sitemap Seo' do
    selectable_column
    column 'Controller' do |sitemap_seo|
      sitemap_seo.sitemap_controller.titleize
    end
    column 'Action' do |sitemap_seo|
      sitemap_seo.sitemap_action.titleize
    end
    column :priority
    column 'Period' do |sitemap_seo|
      sitemap_seo.period.titleize
    end
    column :status
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :sitemap_controller, input_html: { readonly: true }
      f.input :sitemap_action, input_html: { readonly: true }
      f.input :priority
      f.input :period, as: :select, collection: SitemapSeo.periods.keys.map {|e|[e.titleize, e]}
      f.input :status
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end

ActiveAdmin.register GoogleAnalyticSeo do
  menu label: 'Google Analytics', priority: 4, parent: 'SEOData'
  config.filters = false
  actions :all, except: %i[destroy new]

  show title: proc { |google_analytic| "#{google_analytic.title.titleize}" } do
    attributes_table do
      row 'Title' do |google_analytic|
        google_analytic.title.titleize
      end
      row :content
      row :created_at
      row :updated_at
    end
  end

  index title: 'Google Analytics' do
    column 'Title' do |google_analytic|
      google_analytic.title.titleize
    end
    column :content
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :title, input_html: { readonly: true }
      f.input :content
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end