class User < ApplicationRecord
  has_many :meetings, dependent: :destroy
  has_many :comments, through: :meetings, dependent: :destroy
  has_many :payment_cards, dependent: :destroy

  validates :phone, phone: true

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  def admin?
    AdminUser.find_by(email: self.email) ? true : false
  end
end
