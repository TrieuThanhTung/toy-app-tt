require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present " do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email address should be unique" do
    duplicated_user = @user.dup
    duplicated_user.email = duplicated_user.email.upcase
    @user.save
    assert duplicated_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 1
    assert_not @user.valid?
    end
    test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
    end

    test "authenticated? should return false for a user with nil digest" do
      assert_not @user.authenticated?(:remember, "")
    end
end
