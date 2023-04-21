class Viewer < User
  belongs_to :user, foreign_key: :created_by, optional: true
end