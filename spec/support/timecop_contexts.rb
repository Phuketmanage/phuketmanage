# frozen_string_literal: true

def extract_travel_time(time)
  case time
  when Proc
    instance_exec(&time)
  when true
    nil
  else
    time
  end
end

RSpec.configure do |config|
  # Around filter that freezes time for context/describe at some moment.
  #
  # @example
  #   describe '#some_method', freeze: '24.12.2014 23:00' do
  #   describe MyClass, freeze: Date.current.beginning_of_week + 2.days do
  #
  # @example Freeze at current time
  #   context 'freeze to now', freeze: true do
  config.around(:each, freeze: ->(value) { value.present? }) do |example|
    # Default is current time rounded to seconds
    time = extract_travel_time(example.metadata[:freeze]) || Time.current.change(usec: 0)
    raise "Only travel or freeze:#{example.location}" if example.metadata[:travel]

    Timecop.freeze(time) { example.run }
  end

  # Around filter, that makes a time travel for context/describe to some moment.
  #
  # @example
  #   describe MyClass, travel: Time.current.beginning_of_week(:wednesday) do
  #   context 'travel', travel: '2014-03-09 [sunday]' do
  #
  # @example Use lambda if need to use let values in time calculation
  #   context 'travel', travel: -> { 15.days.since(user.created_at) } do
  config.around(:each, travel: ->(value) { value.present? }) do |example|
    time = extract_travel_time(example.metadata[:travel])
    raise "Invalid travel option specified: #{example.location}" unless time
    raise "Only travel or freeze: #{example.location}" if example.metadata[:freeze]

    Timecop.travel(time) { example.run }
  end
end
