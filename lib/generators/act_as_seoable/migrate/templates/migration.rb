class CreateDynamicSeo < ActiveRecord::Migration
  def self.up
    create_table :dynamic_seo do |t|
      t.column :seoable_type, :string, null: false
      t.column :seoable_id, :integer, null: false
      t.column :title, :string, null: false, default: ''
      t.column :description, :text, null: false, default: ''
      t.column :keywords, :text, null: false, default: ''
    end

    add_index :dynamic_seo, %i[seoable_type seoable_id], unique: true
  end

  def self.down
    drop_table :dynamic_seo
  end
end