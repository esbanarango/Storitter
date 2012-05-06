namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_posts
    make_relations
  end
end

def make_users
  99.times do |n|
    username  = Faker::Internet.user_name
    email = Faker::Internet.email
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    User.create!(username:     username,
                 email:    email,
                 first_name: first_name,
                 last_name: last_name)
  end
end

def make_posts
  users = User.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.posts.create!(message: content) }
  end
end

def make_relations
  users = User.all
  user  = users.first
  following_users = users[2..50]
  followers      = users[3..40]
  following_users.each { |following| user.follow!(following) }
  followers.each      { |follower| follower.follow!(user) }
end
