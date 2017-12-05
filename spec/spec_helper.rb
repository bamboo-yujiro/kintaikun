require 'database_cleaner'
require 'factory_girl_rails'

RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.include FactoryGirl::Syntax::Methods #FactoryGirl 接頭辞省略
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    # be_bigger_than(2).and_smaller_than(4).description
    #   # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #   # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # Poltergeist
  require 'capybara/poltergeist'
  #Capybara.default_driver = :poltergeist
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, {
        debug: true,
        js_errors: false,
        phantomjs_logger: File.open("#{Rails.root}/log/test_phantomjs.log", "a"),
        timeout: 5
    })
  end
  Capybara.default_max_wait_time = 5
  Capybara.javascript_driver = :poltergeist

  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  # Support
  Dir[Rails.root.join("spec/support/*.rb")].each {|f| require f}
  include LoginMacros
  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  # Cleaner
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end

end
