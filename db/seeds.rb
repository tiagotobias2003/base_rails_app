

user = User.create(email: 'user@example.com', password: '123456', password_confirmation: '123456', confirmed_at: Time.now)
puts "User created: #{user.email}"

user2 = User.create(email: 'user2@example.com', password: '123456', password_confirmation: '123456', confirmed_at: Time.now)
puts "User created: #{user2.email}"

10.times do
  user.posts.create(title: Faker::Lorem.sentence, body: Faker::Lorem.paragraph, user: user)
  user2.posts.create(title: Faker::Lorem.sentence, body: Faker::Lorem.paragraph, user: user2)
end

puts "Posts created: #{user.posts.count}"
puts "Posts created: #{user2.posts.count}"

puts "Users created: #{User.count}"
puts "Posts created: #{Post.count}"
