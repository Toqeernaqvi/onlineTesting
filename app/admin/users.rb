ActiveAdmin.register User do
  menu false
  permit_params :username, :email, :password, :password_confirmation, :created_by

  controller do
    def create
      create! { admin_users_url }
    end
    def update
      update! { admin_users_url }
    end
  end

  index :download_links => false do
    #selectable_column
    id_column
    column :username
    column :email
    column :created_at
      column (:created_by) { |t| t.user }
    actions
  end
  filter :username
  filter :email
  filter :created_at
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
  controller do
    def update
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end
      super
    end
  end
end