ActiveAdmin.register Role do
  menu parent: 'إعدادات'
	actions :all, except: [:destroy]
	permit_params :title, :title_ar, accessibility_rule_ids: []

	index do
    column :id
    column :title
    column :title_ar
    column :accessibility_rules do |role|
      role.accessibility_rules.pluck(:name).join(", ")
    end
    column :created_at
    column :updated_at
    actions 
  end

  show do |role|
    attributes_table do
      row :id
      row :title
      row :title_ar
      row :accessibility_rules do
        role.accessibility_rules.pluck(:name).join(", ")
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end


  form do |f|
    f.inputs do
      f.input :title
      f.input :title_ar
      f.input :accessibility_rules , as: :check_boxes
    end
    f.actions
  end
end
