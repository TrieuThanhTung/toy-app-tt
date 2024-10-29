require 'rails_helper'

RSpec.describe User, type: :model do

  it "user is valid with valid attributes" do
    should validate_presence_of(:name)
    should validate_presence_of(:email)
    should validate_presence_of(:password)
  end

  it "user is valid without age" do
    user = User.new(name: "test-name", email: "test-email@gmai.com", password: "password")
    expect(user).to be_valid
  end

  it "user is invalid without name" do
    should validate_presence_of(:name)
  end

  it "user is invalid with name less than 6 character" do
    user = User.new(name: "test", age: 20, email: "test-email@gmai.com", password: "password")
    expect(user).to_not be_valid
  end

  it "user is invalid without email" do
    should validate_presence_of(:email)
  end

  it "user is invalid without password" do
    should validate_presence_of(:password)
  end

  it "user is invalid with password less than 6 characters" do
    user = User.new(name: "test", age: 20, email: "test-email@gmai.com", password: "pass")
    expect(user).to_not be_valid
  end
end
