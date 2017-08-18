ActiveAdmin.register Team do
  menu parent: 'إعدادات'
  permit_params :name
  actions :all, except: [:show, :edit, :update]

end
