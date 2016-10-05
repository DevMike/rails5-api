require "rails_helper"

RSpec.describe Friendship, :type => :model do
  it { validate_presence_of(:user) }
  it { validate_presence_of(:friend) }

  it { belong_to(:user) }
  it { belong_to(:friend) }
end