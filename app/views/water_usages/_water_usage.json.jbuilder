json.extract! water_usage, :id, :house_id, :date, :amount, :created_at, :updated_at
json.url water_usage_url(water_usage, format: :json)
