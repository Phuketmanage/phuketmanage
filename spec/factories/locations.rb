# frozen_string_literal: true

# == Schema Information
#
# Table name: locations
#
#  id         :bigint           not null, primary key
#  descr_en   :text
#  descr_ru   :text
#  name_en    :string
#  name_ru    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
Faker::Config.locale = :en

FactoryBot.define do
  factory :location do
    name_en { Faker::Address.city }
  end
end
