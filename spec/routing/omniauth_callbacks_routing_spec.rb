require 'rails_helper'

RSpec.describe "OmniauthCallbacksControllers", type: :routing do
  describe "routing" do
    it "routes to #google_oauth2" do
      expect(post: "/users/auth/google_oauth2").to route_to("users/omniauth_callbacks#passthru")
    end
    it "routes to #google_oauth2_callback" do
      expect(post: "/users/auth/google_oauth2/callback").to route_to("users/omniauth_callbacks#google_oauth2")
    end
    it "routes to #github" do
      expect(post: "/users/auth/github").to route_to("users/omniauth_callbacks#passthru")
    end
    it "routes to #github_callback" do
      expect(post: "/users/auth/github/callback").to route_to("users/omniauth_callbacks#github")
    end
    it "routes to #facebook" do
      expect(post: "/users/auth/facebook").to route_to("users/omniauth_callbacks#passthru")
    end
    it "routes to #facebook_callback" do
      expect(post: "/users/auth/facebook/callback").to route_to("users/omniauth_callbacks#facebook")
    end
  end
end
