require 'rails_helper'

RSpec.describe User, type: :model do

  it "user is valid with valid attributes" do
    user = User.new(name: "test-name", age: 20, email: "test-email@gmai.com", password: "password")
    expect(user).to be_valid
  end

  it "user is valid without age" do
    user = User.new(name: "test-name", email: "test-email@gmai.com", password: "password")
    expect(user).to be_valid
  end

  it "user is invalid without name" do
    user = User.new(email: "test-email@gmai.com", password: "password")
    expect(user).to_not be_valid
  end

  it "user is invalid without name's length at least 6 character" do
    user = User.new(name: "test", age: 20, email: "test-email@gmai.com", password: "password")
    expect(user).to_not be_valid
  end


  it "user is invalid without email" do
    user = User.new(name: "test-name", age: 20, password: "password")
    expect(user).to_not be_valid
  end

  it "user is invalid without email" do
    user = User.new(name: "test-name", age: 20, email: "test-email@gmai.com")
    expect(user).to_not be_valid
  end
end
