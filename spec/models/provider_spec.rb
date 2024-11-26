require 'rails_helper'

RSpec.describe Provider, type: :model do
  let(:user) {
    create(:user)
  }

  it "Provider is not valid without a user" do
    should belong_to(:user)
  end

  it "Provider is not valid without a name" do
    should validate_presence_of(:name)
  end

  it "Provider is not valid without uid" do
    should validate_presence_of(:uid)
  end
end
