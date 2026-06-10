class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :destroy

  after_create :assign_default_role

  def display_name
    profile&.full_name.presence || email.split("@").first
  end

  def admin?
    has_role?(:admin)
  end

  def promote_to_admin!
    add_role(:admin)
    remove_role(:user)
  end

  def demote_to_user!
    remove_role(:admin)
    add_role(:user) unless has_role?(:user)
  end

  def last_admin?
    admin? && self.class.with_role(:admin).count <= 1
  end

  private

  def assign_default_role
    add_role(:user) if roles.blank?
  end
end
