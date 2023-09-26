module TransactionsHelpers
  def add_transaction(**option)
    visit '/transactions/new'
    fill_in "transaction_date", with: option[:date] || Date.current
    select option[:type], from: 'trsc_type'
    select option[:house_code], from: 'transaction_house_id'
    fill_in 'transaction_de_co', with: option[:de_co]
    fill_in 'transaction[comment_en]', with: ''
    fill_in 'transaction[comment_en]', with: option[:comment_en]
    fill_in 'transaction[comment_ru]', with: ''
    fill_in 'transaction[comment_ru]', with: option[:comment_ru]
    click_button 'Save'
  end
end
