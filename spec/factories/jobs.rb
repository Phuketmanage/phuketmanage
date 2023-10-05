FactoryBot.define do
  factory :job do
    job_type factory: :job_type
    creator factory: :user
  end
end
