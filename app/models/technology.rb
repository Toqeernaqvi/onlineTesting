class Technology < ApplicationRecord
    validates :name, :uniqueness => true
    has_many :questions
    belongs_to :user, foreign_key: :created_by, optional: true

   def initialize(protine)
      @protine = protine
    end
end
