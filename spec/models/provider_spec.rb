require 'rails_helper'

RSpec.describe Provider, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  let(:user) {
    create(:user)
  }

  it "Provider is valid with valid attributes" do
    should belong_to(:user)
    should validate_presence_of(:name)
    should validate_presence_of(:uid)
  end

  it "Provider is not valid without a user_id" do
    new_provider = Provider.new(name: "google_oauth2", uid: "1234555")
    expect(new_provider).to_not be_valid
  end

  it "Provider is not valid without a name" do
    new_provider = Provider.new(user_id: user.id, uid: "1234555")
    expect(new_provider).to_not be_valid
  end

  it "Provider is not valid without uid" do
    new_provider = Provider.new( user_id: user.id, name: "google_oauth2")
    expect(new_provider).to_not be_valid
  end
end
