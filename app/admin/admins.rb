ActiveAdmin.register Admin do
  menu parent: "Users", priority: 0
  permit_params :email, :password, :password_confirmation, :username, :created_by

  controller do
    def create
      create! { admin_admins_url }
    end
    def update
      update! { admin_admins_url }
    end
  end

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
  index :download_links => false do
    #selectable_column
    id_column
    column :username
    column :email
    column (:created_by) { |t| t.user }
    actions
  end
  filter :username
  filter :email
  show do
    h3 current_user.username.capitalize
    attributes_table do
      row :username
      row :email
    end
  end
  controller do
    def update
      if params[:admin][:password].blank? && params[:admin][:password_confirmation].blank?
        params[:admin].delete("password")
        params[:admin].delete("password_confirmation")
      end
      super
    end
  end

end
