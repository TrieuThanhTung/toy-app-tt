require 'rails_helper'

RSpec.describe Room, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  describe "Validations" do
    it { should have_many(:participants).dependent(:destroy) }
    it { should validate_presence_of(:title) }
  end
end
