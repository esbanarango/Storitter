require 'spec_helper'

describe Post do

  let(:user) { FactoryGirl.create(:user) }

  before { @post = user.posts.build(message: "OOOOO SI OOOO SI") }


  subject { @post }

  it { should respond_to(:message) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @post.user_id = nil }
    it { should_not be_valid }
  end

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Post.new(user_id: user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "with blank message" do
    before { @post.message = " " }
    it { should_not be_valid }
  end

  describe "with message that is too long" do
    before { @post.message = "a" * 150 }
    it { should_not be_valid }
  end

end