class Admin < User
  belongs_to :user, foreign_key: :created_by, optional: true
 
  validate :checkNamePresence, on: :update 

  private

  def checkNamePresence
     username = User.where("username =?",username)
     errors.add(:username, "Already taken")
  end
end