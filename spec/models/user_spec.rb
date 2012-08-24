require 'spec_helper'

describe User do
  before(:each) do
    User.delete_all
    @user_attr = FactoryGirl.attributes_for(:user)
  end
  
  it "should create a new instance given a valid attribute" do
    User.create!(@user_attr)
  end

  it "should require email address" do
    no_email = User.new(@user_attr.merge(:email => ""))
    no_email.should_not be_valid
  end

  #it "should require first_name and last_name" do
    #no_name = User.new(@user_attr.merge(:first_name => "", :last_name => ""))
    #no_name.should_not be_valid
  #end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@user_attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@user_attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate email addresses" do
    User.create!(@user_attr)
    user_with_duplicate_email = User.new(@user_attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @user_attr[:email].upcase
    User.create!(@user_attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@user_attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "passwords" do
    before(:each) do
      @user = User.new(@user_attr)
    end

    it "should have a password attribute" do
      @user.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
  end

  describe "password validations" do

    it "should require a password" do
      User.new(@user_attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@user_attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end
    
    it "should reject short passwords" do
      short = "a" * 5
      hash = @user_attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
    
  end
  
  describe "password encryption" do
    
    before(:each) do
      @user = User.create!(@user_attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end
  end
end
