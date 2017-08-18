ActiveAdmin.register Persona do
  menu parent: 'إعدادات'
  permit_params :name, :daily_target, :weekly_target, :monthly_target

  index do
    column :id
    column :name
    column :daily_target
    column :weekly_target
    column :monthly_target
    column :created_at
    column :updated_at
    actions 
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :daily_target
      f.input :weekly_target
      f.input :monthly_target
    end
    f.actions
  end

  show do |persona|
    attributes_table do
      row :id
      row :name
      row :daily_target
      row :weekly_target
      row :monthly_target
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end


end
