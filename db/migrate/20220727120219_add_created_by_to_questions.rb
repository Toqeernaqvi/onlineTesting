class AddCreatedByToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :created_by, :integer
  end
end
