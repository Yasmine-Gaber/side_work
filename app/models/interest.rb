class Interest < ActiveRecord::Base
  validates :daily_target, :weekly_target, :monthly_target, presence: true, :numericality => {:greater_than => 0, only_integer: true}
end
