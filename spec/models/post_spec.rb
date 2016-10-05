require "rails_helper"

RSpec.describe Post, :type => :model do
  it { validate_presence_of(:text) }
  it { validate_presence_of(:user) }

  it { belong_to :user }
  it { have_many :comments }
end