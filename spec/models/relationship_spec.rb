require 'spec_helper'

describe Relationship do

	let(:follower) { FactoryGirl.create(:user) }
	let(:followed) { FactoryGirl.create(:user) }

	# create relationship through follower (user #1)
	# set followed_id to 'followed' user (user #2)
	let(:relationship) { follower.relationships.build(followed_id: followed.id) }
	# could also have done @relationship = follower.relationships.build()
	# thus using instance variable rather than "let"


	subject { relationship }


	it { should be_valid }

	describe "follower methods" do
		it { should respond_to(:follower) }
		it { should respond_to(:followed) }

		# now that we know it responds to these, check that they equal the
		# original let variables we created at the very top for
		# 'follower' and 'followed' 
		its(:follower) { should eq follower }
		its(:followed) { should eq followed }

	end

	describe "when followed id is not present" do
		before { relationship.followed_id = nil }
		it { should_not be_valid }
	end

	describe "when follower id is not present" do
		before { relationship.follower_id = nil }
		it { should_not be_valid }
	end




  #pending "add some examples to (or delete) #{__FILE__}"
end
