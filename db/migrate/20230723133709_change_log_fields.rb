class ChangeLogFields < ActiveRecord::Migration[7.0]
  change_table :logs do |t|
    # Remove columns
    t.remove :before, type: :text
    t.remove :after, type: :text
    t.remove :with, type: :string

    # Rename columns
    t.rename :where, :location
    t.rename :who, :user_email
    t.rename :what, :model_gid

    # Add columns
    t.jsonb :user_roles
    t.jsonb :before_values
    t.jsonb :applied_changes
  end
end
