
class SitemapSeo < ActiveRecord::Base

  validates_presence_of   :sitemap_action, :sitemap_controller
  validates_uniqueness_of :sitemap_action, scope: :sitemap_controller
  validates_numericality_of :priority, greater_than_or_equal_to: 0, less_than_or_equal_to: 1
  

  enum period: { not_available: 0, always: 1, hourly: 2, daily: 3, weekly: 4, monthly: 5,yearly: 6, never: 7 }
end