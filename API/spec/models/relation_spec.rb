require 'spec_helper'

describe Relation do

  let(:follower) { FactoryGirl.create(:user) }
  let(:following) { FactoryGirl.create(:user) }
  let(:relation) do
    follower.relations.build(following_id: following.id)
  end

  subject { relation }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to follower_id" do
      expect do
        Relation.new(follower_id: follower.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "follower methods" do
    before { relation.save }

    it { should respond_to(:follower) }
    it { should respond_to(:following) }
    its(:follower) { should == follower }
    its(:following) { should == following }
  end

  describe "when following id is not present" do
    before { relation.following_id = nil }
    it { should_not be_valid }
  end

  describe "when follower id is not present" do
    before { relation.follower_id = nil }
    it { should_not be_valid }
  end

end