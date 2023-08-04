class Transaction < ApplicationRecord
  the_schema_is "transactions" do |t|
    t.string "ref_no"
    t.bigint "house_id"
    t.bigint "type_id"
    t.bigint "user_id"
    t.string "comment_en"
    t.string "comment_ru"
    t.string "comment_inner"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "date"
    t.bigint "booking_id"
    t.boolean "hidden", default: false
    t.boolean "for_acc", default: false
    t.boolean "incomplite", default: false, null: false
    t.boolean "cash", default: false, null: false
    t.boolean "transfer", default: false, null: false
  end

  # attr_accessor :warnings

  belongs_to :type, class_name: 'TransactionType'
  belongs_to :house, optional: true
  belongs_to :user, optional: true
  belongs_to :booking, optional: true
  has_many :balances, dependent: :destroy
  has_many :balance_outs, dependent: :destroy
  has_many :transaction_files
  has_many :files, dependent: :destroy, foreign_key: 'trsc_id', class_name: 'TransactionFile'
  validates :date, :type, :comment_en, presence: true

  scope :full,              ->(from, to) {
                                where('date >= ? AND date <= ? AND for_acc = false', from, to)
                                .order(:date, :created_at) }
  scope :before,            ->(from) { where('date < ? AND for_acc = false', from) }

  scope :by_cat,            ->(from, to) { joins(:balances)
                                .where('date >= ? AND date <= ? AND for_acc = false', from, to)
                                .group(:type_id)
                                .select(:type_id,
                                        "sum(balances.debit) as debit_sum",
                                        "sum(balances.credit) as credit_sum") }
  scope :acc,               ->(from, to) {
                                joins(:balances)
                                .where('date >= ? AND date <= ? AND hidden = false', from, to)
                                .group('transactions.id')
                                .having('SUM(balances.debit) > 0 OR SUM(balances.credit) > 0')
                                .order(:date, :created_at) }
  scope :acc_before,        ->(from) { where('date < ? AND hidden = false', from) }
  scope :filtered,          ->(filter_ids) { where('type_id !=?',filter_ids) }

  scope :unlinked, -> { where(house_id: nil) }
  scope :for_house,         ->(house_id) { where('house_id = ?', house_id) }
  scope :by_cat_for_owner,  ->(from, to) {
                                joins(:balance_outs)
                                .where('date >= ? AND date <= ? AND for_acc = false', from, to)
                                .group(:type_id)
                                .select(
                                        :type_id,
                                        "sum(balance_outs.debit) as debit_sum",
                                        "sum(balance_outs.credit) as credit_sum") }
  scope :full_acc_for_owner, ->(from, to, owner_id) {
                                where('date >= ? AND date <= ? AND hidden = false AND user_id = ?', from, to, owner_id)
                                .order(:date, :created_at) }
  scope :before_acc_for_owner, ->(from, owner_id) {
                                where('date < ? AND hidden = false AND user_id = ?', from, owner_id).all }

  scope :for_salary,        ->(type_id, start, finish) {
                                joins({booking: :house}, :balances)
                                .where(transactions: {type_id: type_id, date: start..finish})
                                .where('bookings.start': ..finish)
                                .or(
                                  where(transactions: {type_id: type_id, date: ..(start.to_date-1.day)})
                                  .where('bookings.start': start..finish))
                                .group(:id, 'bookings.id', 'houses.id')
                                .select(
                                  :id,
                                  :date,
                                  :booking_id,
                                  'houses.code as house_code',
                                  'bookings.start as booking_start',
                                  'bookings.finish as booking_finish',
                                  "sum(balances.debit) as income")
                                .order(:date) }

  def write_to_balance(type, de_ow, cr_ow, de_co, cr_co)
    types1 = ['Rental']
    types2 = ['Maintenance', 'Laundry', 'Cleaning', 'Welcome packs']
    types3 = ['Top up', 'From guests']
    types4 = %w[Repair Purchases Consumables Improvements]
    types5 = ['Utilities', 'Yearly contracts', 'Insurance', 'To owner', 'Common area', 'Transfer']
    types6 = ['Salary', 'Gasoline', 'Office', 'Suppliers', 'Eqp & Cons', 'Taxes & Accounting', 'Eqp maintenance',
              'Materials']
    types7 = ['Other']
    # Может быт balances и balance_outs будут не нужна если под все операции подойдет одна строка в Transactions
    balance_outs.destroy_all if balance_outs.any?
    balances.destroy_all if balances.any?
    if types1.include?(type)
      errors.add(:base, 'Need to select owner or house') and return if house_id.nil? || user_id.nil?

      balance_outs.create!(debit: de_ow, credit: 0) if de_ow > 0
      balance_outs.create!(debit: 0, credit: de_co) if de_co > 0
      balances.create!(debit: de_co, credit: 0) if de_co > 0
      booking.toggle_status if !booking.nil?
    elsif types2.include?(type)
      if (cr_ow.nil? || cr_ow == 0) && (de_co.nil? || de_co == 0)
        errors.add(:base,
                   '"Pay to outside" and "Pay to Phaethon" can not be blank both')
      end
      errors.add(:base, 'Need to select owner or house') if house_id.nil? && user_id.nil?
      errors.add(:base, 'Need to select house') if user_id.nil?
      return if errors.any?

      if de_co > 0
        balance_outs.create!(debit: 0, credit: de_co)
        balances.create!(debit: de_co)
      else
        balance_outs.create!(debit: 0, credit: cr_ow)
      end
    elsif types3.include?(type)
      errors.add(:base, 'Need to select owner or house') and return if house_id.nil? && user_id.nil?
      errors.add(:base, 'Amount can not be blank') and return if de_ow == 0

      balance_outs.create!(debit: de_ow, credit: 0)
    elsif types4.include?(type)
      errors.add(:base, 'Need to select owner') and return if user_id.nil?
      # errors.add(:base, 'Need to select house') and return if house_id.nil?
      errors.add(:base, 'Amount can not be blank') and return if cr_ow == 0 && cr_co == 0 && de_co == 0

      balance_outs.create!(debit: 0, credit: cr_ow) if cr_ow > 0
      balance_outs.create!(debit: 0, credit: cr_co + de_co) if cr_co + de_co > 0
      balances.create!(debit: cr_co + de_co, credit: 0) if cr_co + de_co > 0
      balances.create!(debit: 0, credit: cr_co) if cr_co > 0
    elsif types5.include?(type)
      errors.add(:base, 'Need to select owner or house') and return if user_id.nil? && house_id.nil?
      errors.add(:base, 'Amount can not be blank') and return if cr_ow == 0

      balance_outs.create!(debit: 0, credit: cr_ow) if cr_ow > 0
    elsif types6.include?(type)
      errors.add(:base, 'Amount can not be blank') and return if cr_co == 0

      balances.create!(debit: 0, credit: cr_co) if cr_co > 0
    elsif types7.include?(type)
      errors.add(:base, 'Amount can not be blank') and return if de_ow == 0 && cr_ow == 0 && de_co == 0 && cr_co == 0

      if de_ow > 0 || cr_ow > 0
        errors.add(:base, 'Need to select owner or house') and return if house_id.nil? && user_id.nil?
        return if errors.any?

        balance_outs.create!(debit: de_ow, credit: 0) if de_ow > 0
        balance_outs.create!(debit: 0, credit: cr_ow) if cr_ow > 0
      end
      balances.create!(debit: de_co, credit: 0) if de_co > 0
      balances.create!(debit: 0, credit: cr_co) if cr_co > 0
    else
      errors.add(:base, 'Transaction type is not programmed yet')

    end
  end

  def set_owner_and_house
    self.user_id = House.find(house_id).owner.id if user_id.nil? && !house_id.nil?

    if house_id.nil? && !booking_id.nil?
      house = Booking.find(booking_id).house
      self.house_id = house.id
      self.user_id = house.owner.id if user_id.nil?
    end
  end

  private

    # def check_if_booking_paid
    #   if type.name_en == 'Rental'
    #     booking.is_paid?
    #   end
    #   # byebug
    # end


  # def log
  #   logger.info self.changes
  # end

  # def check_warnings
  #   # owner same day same text
  #   lt = Transaction.last
  #   ts = Transaction.where('date= ? AND (comment_en = ? OR comment_ru = ?)', lt.date ,lt.comment_en, lt.comment_ru)
  #   warnings = []
  #   @warnings << ["Same day same name: #{lt.date} #{lt.comment_en} / #{lt.comment_ru}"] if ts.count > 1
  #   #ts = Transaction.where(date: lt.date).joins(:balance_outs)
  #   #  .where('balance_outs.debit': lt.balance_outs.)
  #   # bs = ts.where(debit: lt.balance_outs.sum(:debit)
  #   byebug
  #   # self.warnings
  # end
end
