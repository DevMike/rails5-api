require "rails_helper"

RSpec.describe User, :type => :model do
  it { validate_inclusion_of(:role).in_array(User::ROLES) }
  it { validate_presence_of(:email) }
  it { validate_uniqueness_of(:email) }

  context 'email format' do
    subject { FactoryGirl.build(:user, email: email) }

    context 'wrong' do
      let(:email) { 'wrong' }

      it { is_expected.not_to be_valid }
    end

    context 'correct' do
      let(:email) { 'right@gmail.com' }

      it { is_expected.to be_valid }
    end
  end

  it { have_many :friendships }
  it { have_many :friends }
  it { have_many :inverse_friends }
  it { have_many :inverse_friendships }
  it { have_many :blocked_friendships }
  it { have_many :blocked_friends }
  it { have_many :inverse_blocked_friends }
  it { have_many :inverse_blocked_friendships }
  it { have_many :posts }
  it { have_many :comments }

  describe '#all_friends' do
    let!(:user) { create(:user, :with_friends) }

    subject { user.all_friends }

    before { create(:friendship, :of_blocked_friend, friend: user) }

    it { is_expected.to match_array([user.friends.first, user.inverse_friends.first]) }
  end

  describe '#blocked' do
    let!(:user) { create(:user, :with_blocked_friends) }

    subject { user.blocked }

    before { create(:friendship, :of_friend, friend: user) }

    it { is_expected.to match_array([user.blocked_friends.first, user.inverse_blocked_friends.first])}
  end

  describe '#messages' do
    let!(:user) { FactoryGirl.create(:user, :with_messages) }

    subject { user.messages }

    it { is_expected.to match_array([user.sent_messages.first, user.received_messages.first]) }
  end
end