class User < ApplicationRecord
  the_schema_is "users" do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "name"
    t.string "surname"
    t.string "locale"
    t.text "comment"
    t.string "code"
    t.string "tax_no"
    t.boolean "show_comm", default: false
  end

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
  scope :active_owners, ->()  { where('balance_closed = false')}
  scope :inactive_owners, ->()  { where('balance_closed = true')}

  def role?(role_or_roles)
    names = Array.wrap(role_or_roles).map(&:to_s).map(&:capitalize)
    !!roles.find_by(name: names)
  end

  def active_for_authentication? 
    super && !balance_closed?
  end 

  def inactive_message 
    !balance_closed? ? super : :inactive
  end

  def unpaid_bookings(booking_id = nil)
    if !booking_id
      houses.joins(:bookings) .where.not('bookings.status': [Booking.statuses[:paid], Booking.statuses[:block], Booking.statuses[:canceled]])
                              .select('bookings.id', 'bookings.start', 'bookings.finish', 'houses.code')
                              .order('bookings.start')
    else
      houses.joins(:bookings) .where('(status != ? AND status != ? AND status != ?) OR bookings.id = ?',
                                Booking.statuses[:paid], Booking.statuses[:block], Booking.statuses[:canceled], booking_id)
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
end
