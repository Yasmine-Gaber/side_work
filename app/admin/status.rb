ActiveAdmin.register Status do
  menu parent: 'إعدادات'
  permit_params :key, :name

end
