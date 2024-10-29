require 'rails_helper'

RSpec.describe Provider, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  before(:all) do
    user = User.new(name: "test-name", age: 20, email: "test-email@gmai.com", password: "password")
    user.save
  end

  it "Provider is valid with valid attributes" do
    new_provider = Provider.new(user_id: 1, provider_name: "google_oauth2", uid: "1234555")
    expect(new_provider).to be_valid
  end

  it "Provider is not valid without a user_id" do
    new_provider = Provider.new(provider_name: "google_oauth2", uid: "1234555")
    expect(new_provider).to_not be_valid
  end

  it "Provider is not valid without a provider_name" do
    new_provider = Provider.new(user_id: 1, uid: "1234555")
    expect(new_provider).to_not be_valid
  end

  it "Provider is not valid without uid" do
    new_provider = Provider.new(provider_name: "google_oauth2", user_id: 1)
    expect(new_provider).to_not be_valid
  end
end
