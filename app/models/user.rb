class User < ApplicationRecord
  has_and_belongs_to_many :roles
  has_many :houses, foreign_key: 'owner_id'
  has_many :bookings, foreign_key: 'tenant_id'
  has_many :jobs
  has_many :jobs_created, class_name: 'Job', foreign_key: 'creator_id'
  scope :with_role, ->(role) { includes(:roles).where(roles: {name: role}) }

  def role?(role)
    role = role.to_s.dup
    role[0] = role[0].capitalize
    !roles.find_by_name(role).nil?
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
