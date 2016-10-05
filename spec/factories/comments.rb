FactoryGirl.define do
  factory :comment do
    user
    post
    text 'some'
  end
end
