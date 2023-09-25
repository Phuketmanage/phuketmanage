module TransactionsHelpers
  def add_transaction(**option)
    visit '/transactions/new'
    fill_in "transaction_date", with: option[:date] || Date.current
    select option[:type], from: 'trsc_type'
    select option[:house_code], from: 'transaction_house_id'
    fill_in 'transaction_de_co', with: option[:de_co]
    click_button 'Save'
  end
end
