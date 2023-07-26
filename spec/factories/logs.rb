# frozen_string_literal: true

FactoryBot.define do
  factory :log do
    user_email { "admin@test.com" }
    user_roles { "Admin" }
    location  { "prices#update" }
    model_gid { "gid://phuketmanage/Price/55" }
    before_values do
      {
        id: 55,
        amount: 8020,
        house_id: 4,
        season_id: 19,
        created_at: "2023-07-21T13:15:44.380Z",
        updated_at: "2023-07-21T14:03:06.654Z",
        duration_id: 10
      }
    end
    applied_changes do
      {
        amount: 8021,
        updated_at: "2023-07-21T14:14:50.253Z"
      }
    end
  end
end
