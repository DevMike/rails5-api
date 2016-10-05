FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "some#{n}@gmail.com" }
    first_name "MyString"
    sequence(:last_name) {|n| "Doe#{n}" }
    password 'some1234'

    trait :admin do
      role 'admin'
    end

    trait :user do
      role 'user'
    end

    trait :guest do
      role 'guest'
    end

    trait :with_friends do
      after(:create) do |u|
        create(:friendship, :of_friend, friend: u)
        create(:friendship, :of_inverse_friend, user: u)
      end
    end

    trait :with_blocked_friends do
      after(:create) do |u|
        create(:friendship, :of_blocked_friend, friend: u)
        create(:friendship, :of_blocked_inverse_friend, user: u)
      end
    end

    trait :with_messages do
      after(:create) do |u|
        create(:message, :with_receiver, sender: u)
        create(:message, :with_sender, receiver: u)
      end
    end

    trait :with_posts do
      after(:build) do |u|
        u.posts = [build(:post)]
      end
    end
  end
end
