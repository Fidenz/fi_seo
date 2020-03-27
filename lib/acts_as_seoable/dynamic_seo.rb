class DynamicSeo < ActiveRecord::Base
  
  attr_accessible :seoable_type, :seoable_id, :title, :description

  belongs_to :seoable, polymorphic: true
  validates_presence_of   :seoable_type, :seoable_id
  validates_uniqueness_of :seoable_id, scope: :seoable_type
end
