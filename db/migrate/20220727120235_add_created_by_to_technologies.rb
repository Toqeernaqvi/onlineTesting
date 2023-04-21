class AddCreatedByToTechnologies < ActiveRecord::Migration[6.1]
  def change
    add_column :technologies, :created_by, :integer
  end
end
