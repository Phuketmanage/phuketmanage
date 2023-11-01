# == Schema Information
#
# Table name: job_types
#
#  id             :bigint           not null, primary key
#  code           :string
#  color          :string
#  for_house_only :boolean
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :job_type do
    trait :type_manage do
      name { "For management" }
    end
  end
end
