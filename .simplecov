SimpleCov.start 'rails' do
  # any custom configs like groups and filters can be here at a central place
  enable_coverage :branch

  if ENV['CI']
    formatter SimpleCov::Formatter::SimpleFormatter
  else
    formatter SimpleCov::Formatter::MultiFormatter.new([
      SimpleCov::Formatter::SimpleFormatter,
      SimpleCov::Formatter::HTMLFormatter
    ])
  end

  track_files "**/*.rb"
end
