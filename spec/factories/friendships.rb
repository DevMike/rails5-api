FactoryGirl.define do
  factory :friendship do

    trait :of_friend do
      after(:build) do |f|
        f.user = build(:user)
      end
    end

    trait :of_inverse_friend do
      after(:build) do |m|
        m.friend = build(:user)
      end
    end

    trait :of_blocked_friend do
      state 'blocked'

      after(:build) do |f|
        f.user = build(:user)
      end
    end

    trait :of_blocked_inverse_friend do
      state 'blocked'

      after(:build) do |m|
        m.friend = build(:user)
      end
    end
  end
end
