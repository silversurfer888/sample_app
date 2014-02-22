class Relationship < ActiveRecord::Base

	# 'follower_id' - ending of '_id' not needed because
	# rails simply infers the '_id' part given the symbol
	# since belongs_to references a foreign key which always
	# has the _id appended. _id part is defined in the db table
	belongs_to :follower, class_name: "User"
	belongs_to :followed, class_name: "User"

	validates :follower_id, presence: true
	validates :followed_id, presence: true

end
