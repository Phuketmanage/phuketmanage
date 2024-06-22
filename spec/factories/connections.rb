FactoryBot.define do
  factory :connection do
    source
    link { File.absolute_path(Rails.root.join("spec/support/files/calendar.ics")) }
  end
end
