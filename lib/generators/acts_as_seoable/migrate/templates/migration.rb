class CreateDynamicSeo < ActiveRecord::Migration[5.2]
  def self.up
    create_table :dynamic_seos do |t|
      t.string :seoable_type, null: false
      t.integer :seoable_id, null: false
      t.string :title, null: false, default: ''
      t.text :description, null: false, default: ''
      t.text :keywords, null: false, default: ''
    end

    add_index :dynamic_seos, %i[seoable_type seoable_id], unique: true
  end

  def self.down
    drop_table :dynamic_seos
  end
end