class AddComplexityToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :complexity, :integer, default: 0
  end
end
