require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  let(:user) {
    create(:user)
  }

  let(:micropost) {
    create(:micropost)
  }

  let(:valid_comment) {
    {
      'content' => "content",
    }
  }

  let(:invalid_comment) {
    {
      'content' => ""
    }
  }

  let(:valid_reaction) {
    {
      'reaction_type' => "love"
    }
  }

  let(:invalid_reaction) {
    {
      'reaction_type' => "care"
    }
  }

  before do
    post login_path, params: {session: {email: user.email, password: 'password'}}
  end

  describe "POST /microposts/:micropost_id/comments" do

    context "create a new comment" do
      it "works!" do
        post micropost_comments_path(micropost), params: { micropost: valid_comment }
        expect(Micropost.count).to eq(2)
        expect(response).to have_http_status(:created)
      end

      it " fail!" do
        post micropost_comments_path(micropost), params: { micropost: invalid_comment }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST /microposts/:micropost_id/comments/:comment_id/reply" do
    before do
      post micropost_comments_path(micropost), params: { micropost: valid_comment }
    end

    context "create a new comment(reply)" do
      it "works!" do
        post micropost_comment_reply_path(micropost_id: micropost.id, comment_id: Micropost.first.id), params: { micropost: valid_comment }
        expect(Micropost.count).to eq(3)
        expect(response).to have_http_status(:created)
      end

      it " fail!" do
        post micropost_comment_reply_path(micropost_id: micropost.id, comment_id: Micropost.first.id), params: { micropost: invalid_comment }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST /microposts/:micropost_id/react" do

    context "create a new reaction for posts or comments" do
      it "works!" do
        post micropost_react_path(micropost), params: valid_reaction
        expect(Reaction.count).to eq(1)
        expect(response).to have_http_status(:created)
      end

      it "raises an ArgumentError for an invalid reaction_type" do
        expect {
          post micropost_react_path(micropost), params: invalid_reaction
        }.to raise_error(ArgumentError, "'care' is not a valid reaction_type")
      end
    end

    context "remove a reaction" do
      before do
        post micropost_react_path(micropost), params: valid_reaction
      end

      it "works!" do
        post micropost_react_path(micropost), params: valid_reaction
        expect(Reaction.count).to eq(0)
        expect(response).to have_http_status(:accepted)
      end
    end
  end
end

