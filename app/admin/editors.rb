ActiveAdmin.register Editor do
  menu parent: "Users", priority: 1
  permit_params :username, :email, :password, :password_confirmation, :created_by

  controller do
    def create
      create! { admin_editors_url }
    end
    def update
      update! { admin_editors_url }
    end
  end

  index  :download_links => false do
    #selectable_column
    id_column
    column :username
    column :email
    column (:created_by) { |t| t.user }
    actions
  end
  filter :username
  filter :email
  form do |f|
    f.inputs do
      f.input :username
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :created_by, :input_html => { :value => current_user.id }, as: :hidden
    end
    f.actions
  end
  show do
    h3 current_user.username.capitalize
    attributes_table do
      row :username
      row :email
    end
  end
  controller do
    def update
      if params[:editor][:password].blank? && params[:editor][:password_confirmation].blank?
        params[:editor].delete("password")
        params[:editor].delete("password_confirmation")
      end
      super
    end
  end
end
