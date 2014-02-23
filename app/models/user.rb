class User < ActiveRecord::Base
	has_many :microposts, dependent: :destroy # allows dependent microposts by user to also be deleted
					# when user is deleted

	# User can 'follow' many other users
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy	

	# 'followed_users' is a customized name we want user to be responsive to
	# ie user.followed_users
	# The people this guy is following
	# For that to work, we need it to reference the followed_id
	# in the relationships table using 'has_many through'
	has_many :followed_users, through: :relationships, source: :followed
	

	# 'followers' - we want user.followers to give list of people
	# following the specified user
	# so we reverse the Relationships table and specify 
	# foreign key as 'followed_id', then through association grab the
	# 'follower_id' column through referencing 'followers' plural
	has_many :reverse_relationships, foreign_key: "followed_id",
											class_name: "Relationship",
											dependent: :destroy
	has_many :followers, through: :reverse_relationships, source: :follower


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
		#Micropost.where("user_id = ?", id) # "?" ensures variable 'id' is properly escaped
							# before being used in SQL query
							# same as 'microposts' - which references all microposts of the user
							# But eventually want not just this user's microposts -- but the
							# microposts of the folks he's following
							# Otherwise user.microposts would've been fine, rather we want user.feed
		# rather than show posts by user, show posts by users the user follows
		Micropost.from_users_followed_by(self) 
	end

	def following?(other_user)
		# if find a follow entry to other_user, then return yes
		relationships.find_by(followed_id: other_user.id)
	end

	# ! means exception created if fail
	def follow!(other_user)
		# same as user.relationships.create or self.relationships.create
		relationships.create!(followed_id: other_user.id)
	end

	def unfollow!(other_user)
		relationships.find_by(followed_id: other_user.id).destroy
	end

	private

		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end
end
