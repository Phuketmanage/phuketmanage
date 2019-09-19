json.extract! transaction_type, :id, :name_en, :name_ru, :debit_company, :credit_company, :debit_owner, :credit_owner, :created_at, :updated_at
json.url transaction_type_url(transaction_type, format: :json)
