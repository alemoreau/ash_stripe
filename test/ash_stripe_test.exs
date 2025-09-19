defmodule AshStripeTest do
  use AshStripe.TestCase
  
  test "configuration works" do
    config = AshStripe.config()
    assert config.api_key == "sk_test_example"
    assert config.api_version == "2025-02-24.acacia"
    assert config.base_url == "https://api.stripe.com"
  end
  
  test "can create new configuration" do
    config = AshStripe.new(api_key: "custom_key")
    assert config.api_key == "custom_key"
  end
end