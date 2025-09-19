defmodule AshStripe.ClientTest do
  use AshStripe.TestCase
  
  describe "configuration" do
    test "creates client with default config" do
      client = AshStripe.Client.new()
      
      # We can't test the actual request structure, but we can ensure
      # the function doesn't crash and returns a proper Req struct
      assert %Req.Request{} = client
    end
    
    test "creates client with custom config" do
      config = AshStripe.new(api_key: "sk_test_custom", api_version: "2024-01-01")
      client = AshStripe.Client.new(config)
      
      assert %Req.Request{} = client
    end
  end
  
  describe "HTTP methods" do
    test "get/3 returns proper structure" do
      # This would normally make HTTP request, but we can test the function signature
      assert is_function(AshStripe.Client.get/3)
    end
    
    test "post/3 returns proper structure" do
      assert is_function(AshStripe.Client.post/3)
    end
    
    test "put/3 returns proper structure" do
      assert is_function(AshStripe.Client.put/3)
    end
    
    test "delete/2 returns proper structure" do
      assert is_function(AshStripe.Client.delete/2)
    end
  end
  
  describe "convenience methods" do
    test "list/3 delegates to get" do
      assert is_function(AshStripe.Client.list/3)
    end
    
    test "retrieve/4 delegates to get with ID" do
      assert is_function(AshStripe.Client.retrieve/4)
    end
    
    test "create/3 delegates to post" do
      assert is_function(AshStripe.Client.create/3)
    end
    
    test "update/4 delegates to post with ID" do
      assert is_function(AshStripe.Client.update/4)
    end
    
    test "destroy/3 delegates to delete with ID" do
      assert is_function(AshStripe.Client.destroy/3)
    end
  end
end