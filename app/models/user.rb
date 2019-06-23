class User < ApplicationRecord
  has_and_belongs_to_many :roles

  def role?( role )
    !roles.find_by_name( role.to_s.camelize ).nil?
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
