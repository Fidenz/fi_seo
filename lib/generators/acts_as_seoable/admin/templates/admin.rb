
ActiveAdmin.register_page 'SEOData' do
  menu label: 'SEO Data', url: '#'
end

ActiveAdmin.register StaticSeo do
  menu label: 'Static Pages', priority: 2, parent: 'SEOData'
  config.filters = false
  actions :all, except: %i[destroy new]

  show do
    attributes_table do
      row('Controller', &:seoable_controller)
      row('Action', &:seoable_action)
      row :title
      row :description
      row :keywords
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

  controller do
    def permitted_params
      params.permit!
    end
  end
end

ActiveAdmin.register DynamicSeo do
  menu label: 'Dynamic Pages', priority: 1, parent: 'SEOData'
  config.filters = false
  actions :all, except: %i[destroy new]

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