ActiveAdmin.register Question do
  config.batch_actions = false
  config.action_items.delete_if { |item|
    # item is an ActiveAdmin::ActionItem
    item.display_on?(:edit)
  }
    menu priority: 1
   config.sort_order = 'id_asc'
  permit_params :question, :answer, :technology_id, :marks, :status, :complexity, :user_id, :created_by
  #filters
  filter :id, :label=> "Search By Question id"
  filter :status
  filter :technology_id, :as => :select, multiple: true, :collection => proc {(Technology.all).map{|c| [c.name,c.id]}}
  # scope("Questions") { |scope| scope.where(id: Question.pluck(:id).shuffle[1..10])}
  # scope(" Or Questions") { |scope| scope.where(id: Question.pluck(:id).shuffle[1..15])}
  filter :marks
  # member_action
  member_action :approve, method: :post, only: :index do
  end

  action_item :view, only: :index, priority: 0 do
    link_to 'Print Questionnaire', question_filter_form_path
  end

  controller do
    def create
      create! { admin_questions_url }
    end

    def update
      update! { admin_questions_url }
    end

    def action_methods
      if current_user.admin?
         super - ['destroy']
      elsif !current_user.admin?
        super - ['destroy','edit']
      end
    end
  end

  member_action :delete, method: :get do
    question = Question.find(params[:id])
    if question.delete
      redirect_to admin_questions_path, notice: "Question has been successfully deleted"
    end
  end

  #show page
  show do
    attributes_table do
      row :technology
      row (:question) { |t| strip_tags(t.question) }
      row (:answer) { |t| strip_tags(t.answer) }
      row :created_at
      row :updated_at
      row :marks
      row :complexity
      row :status do |s|
        if s.status == false
          status_tag(:Pending)
        else
          status_tag(:Approved)
          end
      end

     end
  end
  # form
  form do |f|
      f.inputs do
        f.input :technology_id, :as => :select, :collection => Technology.all.map {|u| [u.name, u.id]}, :include_blank => true, :prompt => 'Select Technology'
        # f.label "question*", input_html:{label:"asa" },class: "label-margin"
        f.input :question, as: :quill_editor, input_html: {data: { options: { modules: { toolbar: [
          ['bold', 'italic', 'underline'],
          ['code-block'],
          [{ 'list': 'ordered' }, { 'list': 'bullet'}],
          [{ 'align': []}],
          [{ 'size': [] }],
          ['image'],
          [ 'clean' ]] } } } }
          # f.label "answer*", class: "label-margin"
        f.input :answer, as: :quill_editor, input_html: { data: { options: { modules: { toolbar: [
          ['bold', 'italic', 'underline'],
          ['code-block'],
          [{ 'list': 'ordered' }, { 'list': 'bullet'}],
          [{ 'align': []}],
          [{ 'size': [] }],
          ['image'],
          [ 'clean' ]] } } } }
        f.input :marks, as: :number, :input_html => { :in => 1..10, :step => 1 }
        f.input :complexity, as: :radio, collection: Question.complexities.keys.to_a
        f.input :status, label: "Approved" if current_user.admin?
        f.input :user_id, :input_html => { :value => current_user.id }, as: :hidden
        f.input :created_by, :input_html => { :value => current_user.id }, as: :hidden

      end
      f.actions
    end

  #index
  index :download_links => false do
    selectable_column
      column :id
      column :technology
      column (:question) { |t| strip_tags(t.question).truncate(50)}
      if current_user.type == "Admin"
        column (:answer) { |t| strip_tags(t.answer).truncate(50)}
      end
      column :marks, sortable: false
      column :complexity
      if current_user.admin?
        column :status do |s|
          if s.status == false
          status_tag(:"Pending")
          link_to('Approve!', approve_admin_question_path(s), class: "view_link member_link", method: :post)
        else
          status_tag(:Approved)
          end
        end
        else
          column :status do |s|
            if s.status == false
            status_tag(:"Pending")
          else
            status_tag(:Approved)
            end
          end
      end
      column (:created_by) { |t| t.user }
       actions do |question|
        if question.user_id == current_user.id
           item('Delete', delete_admin_question_path(question.id),class: [:member_link, :delete_btn])
        end
      end
  end
  #controller
  controller do

    def scoped_collection
      if current_user.type == "Viewer"
        Question.where(status: true)
      else
        Question.all
      end
    end
    def approve
      question = Question.find(params[:id])
      question.status = true
      if question.save
        resource.status = true
        resource.save
        redirect_to admin_questions_path, notice: 'Question Approved!'
      end
    end
    def pdf_content
    end
    def download_pdf
      respond_to do |format|
        format.html
        format.pdf do
          render pdf: 'mypdf', template: 'admin/questions/pdf_content'
        end
      end
    end
  end
end
