# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.create!(name: "Example User",
      email: "rails@gmail.org",
      password:
      "abcd1234",
      password_confirmation: "abcd1234",
      admin:
      true,
      activated: true,
      activated_at: Time.zone.now)

User.create!(name: "Example Second User",
             email: "rails2@gmail.org",
             password:
               "abcd1234",
             password_confirmation: "abcd1234",
             activated: true,
             activated_at: Time.zone.now)

# Generate a bunch of additional users.
99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
  email: email,
  password:
  password,
  password_confirmation: password,
  activated: true,
  activated_at: Time.zone.now)
end

100.times do |n|
  content = Faker::Lorem.paragraph
  user_id = 1
  Micropost.create!(content: content, user_id: user_id)
end

users = User.all
user = User.find(1)
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
