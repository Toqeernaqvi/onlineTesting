class User < ApplicationRecord
  validates :username, :email, presence: true
  validates :password, :password_confirmation, presence: true, on: :create
  validates :password, confirmation: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :questions
  has_many :technologies
  has_many :viewers
  has_many :editors

  devise :database_authenticatable, :validatable
    # roles
    def admin?
      type == 'Admin'
    end
    def viewer?
      type == 'Viewer'
    end
    def editor?
      type == 'Editor'
    end
  end