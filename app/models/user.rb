class User < ActiveRecord::Base
	belongs_to :country
	has_many :articles
end
