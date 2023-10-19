# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# FactoryBot.define do
#   factory :role do
#     trait :admin do
#       name { "Admin" }
#     end
#     trait :manager do
#       name { "Manager" }
#     end
#     trait :accounting do
#       name { "Accounting" }
#     end
#     trait :owner do
#       name { "Owner" }
#     end
#     trait :client do
#       name { "Client" }
#     end
#     trait :guest_relation do
#       name { "Guest relation" }
#     end
#     trait :gardener do
#       name { "Gardener" }
#     end
#     trait :transfer do
#       name { "Transfer" }
#     end
#     trait :maid do
#       name { "Maid" }
#     end
#   end
# end
