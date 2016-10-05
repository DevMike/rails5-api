# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

p 'Load data...'
admin = User.create!(first_name: 'Mike', last_name: 'Zhyzh', email: 'zarechenskiy.mihail@gmail.com', role: 'admin', password: 'qwerty321')
friend = User.create!(first_name: 'John', last_name: 'Doe', email: 'doe@fake.com', role: 'user', password: 'qwerty321')
blocked_friend = User.create!(first_name: 'Peter', last_name: 'Roe', email: 'roe@fake.com', role: 'user', password: 'qwerty321')

Friendship.create!(user: admin, friend: friend)
Friendship.create!(user: admin, friend: blocked_friend, state: 'blocked')

Message.create!(sender: admin, receiver: friend, body: 'Hi!')

Post.create!(title: 'Some article', text: 'Something very interesting', user: User.first)
Post.create!(title: 'Second article', text: 'Even more interesting', user: User.first)
Post.create!(title: 'Third article', text: 'The most interesting', user: User.first)

Comment.create!(text: 'Wow!', post: Post.last, user: User.last)
Comment.create!(text: "It's amazing!" , post: Post.last, user: User.last)
Comment.create!(text: 'Looking forward for new one!', post: Post.last, user: User.last)