require 'rails_helper'

RSpec.describe Micropost, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  context "validations" do
    it { should belong_to(:user) }
    it { should belong_to(:parent).class_name('Micropost').optional }
    it { should have_many(:comments).dependent(:destroy) }
    it { should validate_presence_of(:content) }
  end

end
