class ArticleType < ActiveRecord::Base
	has_many :articles
  before_save :update_key

  def update_key
    self.key = "ArticleType#{ArticleType.all.count + 1}" if self.key.blank?
    self.key = self.key.strip.gsub(" ", "").camelcase
  end
end
