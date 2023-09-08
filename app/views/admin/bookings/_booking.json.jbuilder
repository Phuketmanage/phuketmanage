json.extract! booking, :id, :start, :finish, :house_id, :tenant_id, :created_at, :updated_at
json.url booking_url(booking, format: :json)
