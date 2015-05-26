require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup 
   @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end
  
  test "name should not be too long" do 
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should not be too long" do 
    @user.email = "a" * 256
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do 
    valid_addresses = %w[user@example.com USER@foo.COM A_US_ER@foo.BAR.ORG 
                    first.last@foo.jp foo+bob@baz.cn ]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "Address #{valid_address.inspect} should be valid"
    end
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_foo_at_foo.org user.name @example. 
                          foo@baz_baz.com foo@baz+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "Address #{invalid_address.inspect} should be invalid"
    end
  end
  test "email address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "email address should be saved as lower-case" do
    mixed_case_email = 'Foo@ExamPLe.CoM'
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end