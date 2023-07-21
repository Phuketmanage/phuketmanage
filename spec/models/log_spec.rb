require 'rails_helper'

describe Log, type: :model do
  let(:valid_log) do
    { user_email: 'test@email.com', user_roles: "Admin, Owner", location: "controller#action", model_gid: "prices#update",
      before: {
        id: 55,
        amount: 8020,
        house_id: 4,
        season_id: 19,
        created_at: "2023-07-21T13:15:44.380Z",
        updated_at: "2023-07-21T14:03:06.654Z",
        duration_id: 10
      },
      applied_changes: {
        amount: 8021,
        updated_at: "2023-07-21T14:14:50.253Z"
      } }
  end

  it { should validate_presence_of(:user_email) }
  it { should validate_presence_of(:user_roles) }
  it { should validate_presence_of(:location) }
  it { should validate_presence_of(:model_gid) }
  it { should validate_presence_of(:before) }
  it { should validate_presence_of(:applied_changes) }

  it 'should be valid' do
    expect do
      create(:log, valid_log)
    end.to change { Log.count }.by(1)
  end
end
