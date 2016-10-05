class Message < ApplicationRecord
  belongs_to :sender, class_name: User
  belongs_to :receiver, class_name: User

  validates :body, presence: true
  validates :sender, presence: true
  validates :receiver, presence: true, uniqueness: { scope: :sender }
end
