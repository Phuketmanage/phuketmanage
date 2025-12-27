# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  balance_closed         :boolean          default(FALSE), not null
#  code                   :string
#  comment                :text
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invited_by_type        :string
#  locale                 :string
#  name                   :string
#  passport               :string
#  phone                  :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  show_comm              :boolean          default(FALSE)
#  surname                :string
#  tax_no                 :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :bigint
#
# Indexes
#
#  index_users_on_email                              (email) UNIQUE
#  index_users_on_invitation_token                   (invitation_token) UNIQUE
#  index_users_on_invitations_count                  (invitations_count)
#  index_users_on_invited_by_id                      (invited_by_id)
#  index_users_on_invited_by_type_and_invited_by_id  (invited_by_type,invited_by_id)
#  index_users_on_reset_password_token               (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "qweasd" }
    trait :admin do
      roles { [Role.find_or_create_by(name: 'Admin')] }
    end
    trait :manager do
      roles { [Role.find_or_create_by(name: 'Manager')] }
    end
    trait :accounting do
      roles { [Role.find_or_create_by(name: 'Accounting')] }
    end
    trait :owner do
      roles { [Role.find_or_create_by(name: 'Owner')] }
    end
    trait :client do
      roles { [Role.find_or_create_by(name: 'Client')] }
    end
    trait :guest_relation do
      roles { [Role.find_or_create_by(name: 'Guest relation')] }
    end
    trait :gardener do
      roles { [Role.find_or_create_by(name: 'Gardener')] }
    end
    trait :transfer do
      roles { [Role.find_or_create_by(name: 'Transfer')] }
    end
    trait :maid do
      roles { [Role.find_or_create_by(name: 'Maid')] }
    end
  end
end
