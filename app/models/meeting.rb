class Meeting < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validate :end_after_start
  validates :start_time, :end_time, :presence => true, :overlap => {:scope => "user_id"}

  private
  def end_after_start
    return if end_time.blank? || start_time.blank?
  
    if end_time <= start_time
      errors.add(:end_time, "must be after the start time") 
    end 
  end
end