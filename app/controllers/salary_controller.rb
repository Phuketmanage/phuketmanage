class SalaryController < ApplicationController
  load_and_authorize_resource :class => false
  layout 'admin'

  def index
  end

  def calc
    @from = params[:from]
    @to = params[:to]
    if !@from.present? && !@to.present?
      @from = Time.zone.now.in_time_zone('Bangkok').beginning_of_month.to_date
      @to = Time.zone.now.in_time_zone('Bangkok').end_of_month.to_date
    elsif !@from.present? || !@to.present?
      @error = 'Both dates should be selected'
    end

    type_id = TransactionType.find_by(name_en: 'Rental').id
    @ts = Transaction.for_salary(type_id, @from, @to)

  end
end
