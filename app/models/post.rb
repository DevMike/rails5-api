class Post < ApplicationRecord
  has_many :comments
  belongs_to :user

  validates :text, presence: true
  validates :user, presence: true

  def to_json(options=nil)
    super(options.merge(include: [:comments]))
  end
end
