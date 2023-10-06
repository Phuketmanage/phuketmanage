FactoryBot.define do
  factory :job_message do
    job
    sender factory: :user
  end
end
