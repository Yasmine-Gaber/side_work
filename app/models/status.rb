class Status < ActiveRecord::Base
  before_save :update_key

  def update_key
    self.key = "Status#{Status.all.count + 1}" if self.key.blank?
    self.key = self.key.strip.gsub(" ", "").camelcase
  end
end
