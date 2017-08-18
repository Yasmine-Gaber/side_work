ActiveAdmin.register ArticleCountry do
  menu parent: 'إعدادات'
  permit_params :name, :daily_target, :weekly_target, :monthly_target

end
