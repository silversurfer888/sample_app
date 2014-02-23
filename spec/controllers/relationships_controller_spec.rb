require 'spec_helper'

describe RelationshipsController do
	let(:user) { FactoryGirl.create(:user) }
	let(:other_user) { FactoryGirl.create(:user) }

	before { sign_in user, no_capybara: true }
	# no_capybara must be true for PATCH or PUT http methods to work

	# following, test result of ajax
	describe "creating a relationship with Ajax" do

		it "should increment the Relationship count" do
			expect do
				# relationship record needs columns filled
				xhr :post, :create, relationship: { followed_id: other_user.id }
			end.to change(Relationship, :count).by(1)
		end

		it "should respond with success" do
			xhr :post, :create, relationship: { followed_id: other_user.id }
			expect(response).to be_success
		end
	end

	# unfollowing, do the follow first, then test result of ajax
	describe "destroying a relationship with Ajax" do

		before { user.follow!(other_user) }

		let(:relationship) do
			user.relationships.find_by(followed_id: other_user.id)
		end

		it "should decrement the Relationship count" do
			expect do
				# simply identify relationship record to be deleted
				xhr :delete, :destroy, id: relationship.id 
			end.to change(Relationship, :count).by(-1)
		end

		it "should respond with success" do
			xhr :delete, :destroy, id: relationship.id
			expect(response).to be_success
		end
	end
end

