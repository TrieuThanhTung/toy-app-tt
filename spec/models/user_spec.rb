require 'rails_helper'

RSpec.describe User, type: :model do

  it "user is valid without age" do
    user = User.new(name: "test-name", email: "test-email@gmai.com", password: "password")
    expect(user).to be_valid
  end

  it "user is invalid without name" do
    should validate_presence_of(:name)
  end

  it "user is invalid with name's length between 6 -> 255" do
    should validate_length_of(:name)
             .is_at_least(6)
             .is_at_most(255)
  end

  it "user is invalid without email" do
    should validate_presence_of(:email)
  end

  it "user is invalid without password" do
    should validate_presence_of(:password)
  end

  it "user is invalid with password less than 6 characters" do
    should validate_length_of(:password).is_at_least(6)
  end
end
