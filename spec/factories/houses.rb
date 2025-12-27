# frozen_string_literal: true

# == Schema Information
#
# Table name: houses
#
#  id                    :bigint           not null, primary key
#  address               :string
#  balance_closed        :boolean          default(FALSE), not null
#  bathrooms             :integer
#  cancellationPolicy_en :text
#  cancellationPolicy_ru :text
#  capacity              :integer
#  code                  :string
#  communal_pool         :boolean
#  description_en        :text
#  description_ru        :text
#  details               :text
#  google_map            :string
#  hide_in_timeline      :boolean          default(FALSE), not null
#  house_no              :string
#  image                 :string
#  kingBed               :integer
#  maintenance           :boolean          default(FALSE)
#  number                :string(10)
#  other_en              :text
#  other_ru              :text
#  outsource_cleaning    :boolean          default(FALSE)
#  outsource_linen       :boolean          default(FALSE)
#  parking               :boolean
#  parking_size          :integer
#  photo_link            :string
#  plot_size             :integer
#  pool                  :boolean
#  pool_size             :string
#  priceInclude_en       :text
#  priceInclude_ru       :text
#  project               :string
#  queenBed              :integer
#  rental                :boolean          default(FALSE)
#  rooms                 :integer
#  rules_en              :text
#  rules_ru              :text
#  seaview               :boolean          default(FALSE)
#  secret                :string
#  singleBed             :integer
#  size                  :integer
#  title_en              :string
#  title_ru              :string
#  unavailable           :boolean          default(FALSE)
#  water_meters          :integer          default(1)
#  water_reading         :boolean          default(FALSE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  house_group_id        :bigint
#  owner_id              :bigint           not null
#  type_id               :bigint           not null
#
# Indexes
#
#  index_houses_on_bathrooms       (bathrooms)
#  index_houses_on_code            (code)
#  index_houses_on_communal_pool   (communal_pool)
#  index_houses_on_house_group_id  (house_group_id)
#  index_houses_on_number          (number) UNIQUE
#  index_houses_on_owner_id        (owner_id)
#  index_houses_on_parking         (parking)
#  index_houses_on_rooms           (rooms)
#  index_houses_on_type_id         (type_id)
#  index_houses_on_unavailable     (unavailable)
#
# Foreign Keys
#
#  fk_rails_...  (house_group_id => house_groups.id)
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (type_id => house_types.id)
#
FactoryBot.define do
  factory :house do
    sequence(:number) { |n| 100_000 + n }
    sequence(:description_en) { |n| "House#{100_000 + n}" }
    sequence(:description_ru) { |n| "Вилла#{100_000 + n}" }
    sequence(:code) { |n| "HS#{100_000 + n}" }
    rooms { Random.rand(1..4) }
    bathrooms { Random.rand(1..3) }
    address { Faker::Address.full_address }
    owner { build(:user, :owner) }
    type { build(:house_type) }
    project { Faker::Address.city }
    unavailable { false }
    after(:create) do |house|
      create_list(:duration, 1, house:)
    end

    trait :with_seasons do
      after(:create) do |house|
        create(:season, ssd: 15, ssm: 4, sfd: 1, sfm: 11, house:)
        create(:season, ssd: 1, ssm: 11, sfd: 1, sfm: 12, house:)
        create(:season, ssd: 1, ssm: 12, sfd: 15, sfm: 12, house:)
        create(:season, ssd: 15, ssm: 12, sfd: 15, sfm: 1, house:)
        create(:season, ssd: 15, ssm: 1, sfd: 1, sfm: 3, house:)
        create(:season, ssd: 1, ssm: 3, sfd: 15, sfm: 4, house:)
        # Creating prices for every season
        house.seasons.map { |season| create(:price, house:, season:, duration: house.durations.first) }
      end
    end
  end
end
