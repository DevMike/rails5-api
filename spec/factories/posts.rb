FactoryGirl.define do
  factory :post do
    user
    text 'some'

    trait(:with_comments) do
      after(:build) do |m|
        m.comments = [build(:comment)]
      end
    end
  end
end
