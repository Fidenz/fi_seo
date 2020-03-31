class StaticSeo < ActiveRecord::Base

  validates_presence_of   :seoable_controller, :seoable_action
  validates_uniqueness_of :seoable_action, scope: :seoable_controller
end
