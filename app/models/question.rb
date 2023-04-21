class Question < ApplicationRecord
  validates :question, :uniqueness => true
  validates :question, :answer, :technology_id, :marks, presence: true
  validates :marks, :inclusion => { :in => 1..10, message: "Please enter marks between 1 to 10"}
  enum complexity: [:Beginner, :Elementary, :Intermediate, :Advanced, :Expert]
  belongs_to :user, foreign_key: :created_by, optional: true
  belongs_to :technology
  
  scope :approved_questions, -> { where(:status => true)}
  # Ex:- scope :active, -> {where(:active => true)}
  
  
  def approve!
    update(status: true)
  end
end


 