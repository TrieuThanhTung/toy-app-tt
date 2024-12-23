require "test_helper"

class FollowingTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:michael)
    @other = users(:archer)
    log_in_as(@user)
  end

  test "should follow a user the standard way" do
    assert_difference "@user.following.count", 1 do
    post relationships_path, params: { followed_id: @other.id }
    end
    end
    test "should follow a user with Ajax" do
    assert_difference "@user.following.count", 1 do
    post relationships_path, xhr: true, params: { followed_id: @other.id }
    end
    end
    test "should unfollow a user the standard way" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference "@user.following.count", -1 do
    delete relationship_path(relationship)
    end
    end
    test "should unfollow a user with Ajax" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference "@user.following.count", -1 do
    delete relationship_path(relationship), xhr: true
    end
    end
end
