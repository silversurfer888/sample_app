class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy # allows dependent microposts by user to also be deleted
          # when user is deleted
  
  before_save {self.email = email.downcase }
  #before_save { email.downcase }
  before_create :create_remember_token
  
  validates :name, presence: true, length: { maximum: 50 }
  #validates :email, presence: true
  
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
          uniqueness: { case_sensitive: false }
  
  validates :password, length: {minimum: 6}
  has_secure_password
  
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  # allow Users model to respond to "feed" which pulls the relevant microposts
  # Each User has a feed so we want to be able to do user.feed
  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id) # "?" ensures variable 'id' is properly escaped
              # before being used in SQL query
              # same as 'microposts' - which references all microposts of the user
              # But eventually want not just this user's microposts -- but the
              # microposts of the folks he's following
              # Otherwise user.microposts would've been fine, rather we want user.feed
              
  end
  

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
