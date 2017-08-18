class Country < ActiveRecord::Base

	def to_s
		self.name_en
	end
end
