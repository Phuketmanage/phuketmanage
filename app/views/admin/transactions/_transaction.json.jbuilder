json.extract! transaction, :id, :ref_no, :house_id, :type_id, :user_id, :comment_en, :comment_ru, :comment_inner,
              :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
