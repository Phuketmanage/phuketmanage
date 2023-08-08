# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  balance_closed         :boolean          default(FALSE), not null
#  code                   :string
#  comment                :text
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invited_by_type        :string
#  locale                 :string
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  show_comm              :boolean          default(FALSE)
#  surname                :string
#  tax_no                 :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :bigint
#
# Indexes
#
#  index_users_on_email                              (email) UNIQUE
#  index_users_on_invitation_token                   (invitation_token) UNIQUE
#  index_users_on_invitations_count                  (invitations_count)
#  index_users_on_invited_by_id                      (invited_by_id)
#  index_users_on_invited_by_type_and_invited_by_id  (invited_by_type,invited_by_id)
#  index_users_on_reset_password_token               (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  has_and_belongs_to_many :roles
  has_many :houses, foreign_key: 'owner_id'
  has_many :bookings, foreign_key: 'tenant_id'
  # has_many :statements, foreign_key: 'owner_id'
  has_many :jobs
  has_many :job_tracks, dependent: :destroy
  has_many :transactions
  has_many :booking_files, dependent: :nullify
  # has_many :jobs_created, class_name: 'Job', foreign_key: 'creator_id'
  has_many :todos
  has_many :todos_created, class_name: 'Todo', foreign_key: 'creator_id'

  scope :with_role, ->(role) { includes(:roles).where(roles: { name: role }) }
  scope :active_owners, -> { where('balance_closed = false') }
  scope :inactive_owners, -> { where('balance_closed = true') }

  def role?(role_or_roles)
    names = Array.wrap(role_or_roles).map(&:to_s).map(&:capitalize)
    !!roles.find_by(name: names)
  end

  def active_for_authentication?
    super && !balance_closed?
  end

  def inactive_message
    balance_closed? ? :inactive : super
  end

  def unpaid_bookings(booking_id = nil)
    if booking_id
      houses.joins(:bookings).where('(status != ? AND status != ? AND status != ?) OR bookings.id = ?',
                                    Booking.statuses[:paid], Booking.statuses[:block], Booking.statuses[:canceled], booking_id)
        .select('bookings.id', 'bookings.start', 'bookings.finish', 'houses.code')
        .order('bookings.start')
    else
      houses.joins(:bookings).where.not('bookings.status': [Booking.statuses[:paid], Booking.statuses[:block], Booking.statuses[:canceled]])
        .select('bookings.id', 'bookings.start', 'bookings.finish', 'houses.code')
        .order('bookings.start')
    end
  end

  # def is_any_of?(role)
  #   role = role.split = if role.kind_of?(String)
  #   result = false
  #   role.each do |r|

  #   end

  # end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, # :registerable,
         :rememberable # , :validatable, :invitable, ,

  private

  def send_devise_notification(notification, *)
    devise_mailer.send(notification, self, *).deliver_later(priority: 0)
  end
end
