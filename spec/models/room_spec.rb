require 'rails_helper'

RSpec.describe Room, type: :model do
  describe "Validations" do
    it { should have_many(:participants).dependent(:destroy) }
    it { should validate_presence_of(:title) }
  end
end
