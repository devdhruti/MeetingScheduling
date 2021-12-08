class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :meeting

  validates :comment, presence: true
end
