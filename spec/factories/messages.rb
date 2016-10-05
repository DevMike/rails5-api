FactoryGirl.define do
  factory :message do
    body 'How is going?'

    trait :with_sender do
      after(:build) do |m|
        m.sender = build(:user)
      end
    end

    trait :with_receiver do
      after(:build) do |m|
        m.receiver = build(:user)
      end
    end
  end
end
