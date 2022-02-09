require 'simplecov'
require 'simplecov-console'
require 'minitest/reporters'
require 'webmock/minitest'
require "minitest/autorun"

class Minitest::Reporters::SpecReporter
  def record_print_status(test)
    print_colored_status(test)
    # rubocop:todo Style/FormatStringToken
    time = test.time
    print(' (%.2fs)' % time) unless time.nil?
    # rubocop:enable Style/FormatStringToken
    test_name = test.name.gsub(/^test_: /, 'test:')
    print pad_test(test_name)
    puts
  end
end

SimpleCov.start 'rails' do
  add_filter 'application_cable'
  add_filter 'application_job.rb'
  add_filter 'application_mailer.rb'
end

Minitest::Reporters.use! Minitest::Reporters::MeanTimeReporter.new


SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console
  ]
)

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/autorun'

class ActiveSupport::TestCase
  extend ActionDispatch::TestProcess
  include WebMock::API
  parallelize(workers: :number_of_processors)

  parallelize_setup do |worker|
    SimpleCov.command_name "#{SimpleCov.command_name}-#{worker}"
  end
  parallelize_teardown do |_worker|
    SimpleCov.result
  end

  # Add more helper methods to be used by all tests here...
  def request_stubber(options_array)
    options_array.map do |options|
      options[:body] ||= ''
      options[:http_method] ||= :get
      options[:http_status] ||= 200
      options[:headers] ||= {}

      stub_request(options[:http_method], options[:url])
        .with(
          headers: {
            'Accept' => '*/*'
          }.merge!(options[:headers])
        ).to_return(status: options[:http_status], body: options[:body], headers: {})
    end
  end

  def json_response(file_name)
    File.read("test/fixtures/mocks/#{file_name}.json")
  end
end
