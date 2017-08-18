ActiveAdmin.register User do
  menu parent: 'أعضاء'
	actions :all, except: [:destroy]
	permit_params :name, :email, :country_id, :type

  index do
    column :id
    column :name
    column :email
    column :country
    column :created_at
    actions 
  end

	form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :country
      f.input :type, :as => :select, :collection => Role.all.map{|r| [r.title, r.title]}
    end
    f.actions
  end

end
