class Editor < User
  belongs_to :user, foreign_key: :created_by, optional: true

end