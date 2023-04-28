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
  before_create :add_type_of_transaction_to_comment
  # after_save :check_warnings, on: [:create, :update]

  def write_to_balance (type, de_ow, cr_ow, de_co, cr_co)
    types1 = ['Rental']
    types2 = ['Maintenance', 'Laundry']
    types3 = ['Top up', 'From guests']
    types4 = ['Repair', 'Purchases', 'Consumables', 'Improvements']
    types5 = ['Utilities', 'Yearly contracts', 'Insurance', 'To owner', 'Common area', 'Transfer']
    types6 = ['Salary', 'Gasoline', 'Office', 'Suppliers', 'Eqp & Cons', 'Taxes & Accounting', 'Eqp maintenance', 'Materials']
    types7 = ['Other']
    # Может быт balances и balance_outs будут не нужна если под все операции подойдет одна строка в Transactions
    balance_outs.destroy_all if balance_outs.any?
    balances.destroy_all if balances.any?
    if types1.include?(type)
      errors.add(:base, 'Need to select owner or house') and return if house_id.nil? || user_id.nil?
      balance_outs.create!(debit: de_ow, credit: 0) if de_ow > 0
      balance_outs.create!(debit: 0, credit: de_co) if de_co > 0
      balances.create!(debit: de_co, credit: 0) if de_co > 0
    elsif types2.include?(type)
      errors.add(:base, '"Pay to outside" and "Pay to Phaethon" can not be blank both') if (cr_ow.nil? || cr_ow == 0) && (de_co.nil? || de_co == 0)
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
    if user_id.nil? && !house_id.nil?
      self.user_id = House.find(house_id).owner.id
    end

    if house_id.nil? && !booking_id.nil?
      house = Booking.find(booking_id).house
      self.house_id = house.id
      self.user_id = house.owner.id if user_id.nil?
    end
  end

  private

  def add_type_of_transaction_to_comment
    cash_type = self.cash ? " T" : " C"
    self.comment_en += cash_type
    self.comment_ru += cash_type
  end

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
