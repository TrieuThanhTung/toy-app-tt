# frozen_string_literal: true

class OmniauthService

  class << self
    def from_omniauth(auth)
      provider = find_provider(auth)
      if provider.nil?
        user = find_or_create_user(auth)
        provider = create_provider(auth, user)
      end
      provider.user
    end

    private
    def find_provider(auth)
      Provider.find_by(uid: auth[:uid], provider_name: auth[:provider])
    end

    def create_provider(auth, user)
      Provider.create!(user: user, provider_name: auth[:provider], uid: auth[:uid])
    end

    def find_or_create_user(auth)
      data = auth[:info]
      user = User.find_by(email: data[:email])
      if user.nil?
        name_user = auth[:provider] != "github" ? data[:name] : data[:nickname]
        new_password = Devise.friendly_token[0, 20]
        user = User.create!(
          name: name_user,
          email: data[:email],
          password: new_password,
          password_confirmation: new_password,
          activated: true,
          activated_at: Time.zone.now
        )
      end
      user
    end
  end
end
