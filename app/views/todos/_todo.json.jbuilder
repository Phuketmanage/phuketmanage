json.extract! job, :id, :job_type_id, :booking_id, :house_id, :date, :time, :comment, :created_at, :updated_at
json.url job_url(job, format: :json)
