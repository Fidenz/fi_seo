class CreateSeoTables < ActiveRecord::Migration[5.2]
  def self.up
    create_table :dynamic_seos do |t|
      t.string :seoable_type, null: false
      t.integer :seoable_id, null: false
      t.string :title, null: false, default: ''
      t.text :description, null: false, default: ''
      t.text :keywords, null: false, default: ''

      t.timestamps
    end

    create_table :static_seos do |t|
      t.string :seoable_controller, null: false
      t.string :seoable_action, null: false
      t.string :title, null: false, default: ''
      t.text :description, null: false, default: ''
      t.text :keywords, null: false, default: ''
      t.boolean :status, null: false, default: false
      t.string :facebook_title, null: false, default: ''
      t.string :facebook_url, null: false, default: ''
      t.string :facebook_type, null: false, default: ''
      t.string :facebook_image, null: false, default: ''
      t.string :facebook_description, null: false, default: ''
      t.string :twitter_title, null: false, default: ''
      t.string :twitter_card, null: false, default: ''
      t.string :twitter_site, null: false, default: ''
      t.string :twitter_image, null: false, default: ''
      t.string :twitter_description, null: false, default: ''

      t.timestamps
    end

    create_table :sitemap_seos do |t|
      t.string :sitemap_controller, null: false
      t.string :sitemap_action, null: false
      t.boolean :status, null: false
      t.decimal :priority, null: false, default: 1
      t.integer :period, null: false, default: 0
      t.boolean :static, null: false, default: false
      
      t.timestamps
    end

    create_table :google_analytic_seos do |t|
      t.string :title, null: false
      t.string :content, null: false, default: ''

      t.timestamps
    end

    GoogleAnalyticSeo.create(title: 'analytic id', content: '')

    add_index :dynamic_seos, %i[seoable_type seoable_id], unique: true
    add_index :static_seos, %i[seoable_controller seoable_action], unique: true
    add_index :sitemap_seos, %i[sitemap_controller sitemap_action], unique: true
  end

  def self.down
    drop_table :dynamic_seos
    drop_table :static_seos
    drop_table :sitemap_seos
    drop_table :google_analytic_seos
  end
end