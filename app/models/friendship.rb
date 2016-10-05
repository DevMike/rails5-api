class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: User

  def blocked?
    state == 'blocked'
  end
end
