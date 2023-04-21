ActiveAdmin.register Technology do
  # filter :questions, :collection => proc {(Question.all).map{|c| [c.question, c.id]}}
  menu priority: 2
  actions :all
  controller do
    def create
      create! { admin_technologies_url }
    end

    def update
      update! { admin_technologies_url }
    end

    def action_methods
      if current_user.admin?
        super - ['destroy']
      else
        super - ['edit', 'destroy', 'new']
      end
    end

  end

  member_action :delete, method: :get do
    technology = Technology.find(params[:id])
    if technology.delete
      redirect_to admin_technologies_path, notice: "Technology has been successfully deleted"
    end
  end


  form do |f|
    f.inputs do
      f.input :name
      f.input :created_by, :input_html => { :value => current_user.id }, as: :hidden
    end
    f.actions
  end
  index :download_links => false do
    #selectable_column
    column :name
    column (:created_by) { |t| t.user }
     actions do |technology|
      if current_user.admin?
        if !technology.questions.exists?
        item('Delete', delete_admin_technology_path(technology.id),class: [:member_link, :delete_btn])
        end
      end
    end
  end
  filter :name
  permit_params :name, :created_by
  show do
    attributes_table do
      row :name
    end
  end
end
