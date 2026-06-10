class User < ApplicationRecord
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :destroy

  def display_name
    profile&.full_name.presence || email.split("@").first
  end
end
