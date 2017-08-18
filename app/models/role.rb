class Role < ActiveRecord::Base
	has_many :users
  has_and_belongs_to_many :accessibility_rules
  before_save :update_title
  after_save :create_dynamic_class

  def update_title
    self.title = "Role#{Role.all.count + 1}" if self.title.blank?
    self.title = self.title.strip.gsub(" ", "").camelcase
  end

  def create_dynamic_class
    dynamic_name = self.title.strip.gsub(" ", "_").camelcase
    Object.const_set(dynamic_name, Class.new(User))
  end
end
