class AccessibilityRule < ActiveRecord::Base
	has_and_belongs_to_many :roles
	validates :key, :name, presence: true
	validates :key, uniqueness: true
end
