class User < ApplicationRecord
  # Include default devise modules.
  include DeviseTokenAuth::Concerns::User

  devise :database_authenticatable, :omniauthable, :trackable

  ROLES = %w(admin user)

  validates :role, inclusion: ROLES
  validates :email, presence: true, format: Devise.email_regexp, uniqueness: true

  has_many :posts
  has_many :comments
  has_many :friendships, ->{ where(state: 'friend') }
  has_many :friends, through: :friendships, source: :friend
  has_many :inverse_friendships, ->{ where(state: 'friend') }, class_name: Friendship, foreign_key: :friend_id
  has_many :inverse_friends, through: :inverse_friendships, source: :user
  has_many :blocked_friendships, ->{ where(state: 'blocked') }, class_name: Friendship
  has_many :blocked_friends, through: :blocked_friendships, source: :friend
  has_many :inverse_blocked_friendships, ->{ where(state: 'blocked') }, class_name: Friendship, foreign_key: :friend_id
  has_many :inverse_blocked_friends, through: :inverse_blocked_friendships, source: :user
  has_many :sent_messages, foreign_key: :sender_id, class_name: Message
  has_many :received_messages, foreign_key: :receiver_id, class_name: Message

  ROLES.each do |r|
    define_method(:"#{r}?") do
      role == r
    end
  end

  def all_friends
    friends + inverse_friends
  end

  def blocked
    blocked_friends + inverse_blocked_friends
  end

  def messages
    sent_messages + received_messages
  end

  private

  def confirmation_required?
    false
  end
end
