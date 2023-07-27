namespace :tests do
  desc "Run test suites"
  task run: :environment do
    sh "rspec"
    sh "rails t"
  end
  desc "Reset test db and precompile assets"
  task setup: :environment do
    sh "RAILS_ENV=test rails db:test:prepare"
    sh "rails assets:precompile "
  end
end
