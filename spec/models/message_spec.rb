require "rails_helper"

RSpec.describe Message, :type => :model do
  it { validate_presence_of(:sender) }
  it { validate_presence_of(:receiver) }
  it { validate_presence_of(:body) }
  it { validate_uniqueness_of(:receiver).scoped_to(:sender) }

  it { belong_to :sender }
  it { belong_to :receiver }
end