require 'spec_helper'

describe User do

	before { @user = User.new(username: "Example User", email: "user@example.com") }

	subject { @user }
	it { should respond_to(:username) }
	it { should respond_to(:email) }

	it { should be_valid }

	describe "when username is not present" do
		before { @user.username = " " }
	    it { should_not be_valid }
	end

	describe "when email is not present" do
	    before { @user.email = " " }
	    it { should_not be_valid }
	end

	#Longer username will be truncated, ie: "Totojskfj" will become "Toto."
	describe "when name is too long" do
		before { @user.username = "a" * 43 }
	    it "should truncate the name" do
	    	@user.save
	    	@user.username.size.should eql(40)
	    end
	end

	# Format email validation
	describe "when email format is invalid" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				@user.should_not be_valid
	    	end
	    end
	end

	describe "when email format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				@user.should be_valid
			end      
		end
	end

	describe "when email address is already taken" do
	    before do
	      user_with_same_email = @user.dup
	      user_with_same_email.email = @user.email.upcase
	      user_with_same_email.save
	    end
	    it { should_not be_valid }
	end



	it { should respond_to(:relations) }
    it { should respond_to(:following_users) }
    it { should respond_to(:reverse_relations) }
  	it { should respond_to(:followers) }
  	it { should respond_to(:following?) }
  	it { should respond_to(:follow!) }

  	describe "following" do
	    let(:other_user) { FactoryGirl.create(:user) }    
	    before do
	      @user.save
	      @user.follow!(other_user)
	    end

	    it { should be_following(other_user) }
	    its(:following_users) { should include(other_user) }

	    describe "following user" do
	      subject { other_user }
	      its(:followers) { should include(@user) }
	    end

	    describe "and unfollowing" do
	    	before { @user.unfollow!(other_user) }
	    	it { should_not be_following(other_user) }
	    	its(:following_users) { should_not include(other_user) }
	    end

	end

end