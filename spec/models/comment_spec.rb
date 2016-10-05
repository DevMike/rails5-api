require "rails_helper"

RSpec.describe Comment, :type => :model do
  it { validate_presence_of(:text) }
  it { validate_presence_of(:user) }
  it { validate_presence_of(:post) }

  it { belong_to :user }
  it { belong_to :post }
end