class GoogleAnalyticSeo < ActiveRecord::Base

  validates_presence_of :title
  validates_presence_of :content, allow_blank: true
end
