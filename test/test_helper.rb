# frozen_string_literal: true

require File.expand_path("../config/environment", __dir__)
require "rails/test_help"
# require 'support/factory_bot'

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    # FactoryBot
    include FactoryBot::Syntax::Methods

    # Devise
    # include Devise::Test::ControllerHelpers
    # include Devise::Test::IntegrationHelpers
  end
end

# Para Capybara
module ActionDispatch
  class IntegrationTest
    include Devise::Test::IntegrationHelpers

    #   # Make the Capybara DSL available in all integration tests
    #   include Capybara::DSL
    #   # Make `assert_*` methods behave like Minitest assertions
    #   include Capybara::Minitest::Assertions
    #   # Reset sessions and driver between tests
    #   # Use super wherever this method is redefined in your individual test classes
    #   def teardown
    #     Capybara.reset_sessions!
    #     Capybara.use_default_driver
    #   end
  end
end
