defmodule AshStripe.ResourcesTest do
  use AshStripe.TestCase
  
  describe "Customer resource" do
    test "has proper primary key" do
      assert Ash.Resource.Info.primary_key(AshStripe.Customer) == [:id]
    end
    
    test "has expected attributes" do
      attributes = Ash.Resource.Info.attributes(AshStripe.Customer)
      attribute_names = Enum.map(attributes, & &1.name)
      
      assert :id in attribute_names
      assert :email in attribute_names
      assert :name in attribute_names
      assert :phone in attribute_names
      assert :metadata in attribute_names
    end
    
    test "has expected actions" do
      actions = Ash.Resource.Info.actions(AshStripe.Customer)
      action_names = Enum.map(actions, & &1.name)
      
      assert :create in action_names
      assert :read in action_names
      assert :update in action_names
      assert :destroy in action_names
      assert :list in action_names
      assert :get_by_id in action_names
    end
  end
  
  describe "Subscription resource" do
    test "has proper primary key" do
      assert Ash.Resource.Info.primary_key(AshStripe.Subscription) == [:id]
    end
    
    test "has expected attributes" do
      attributes = Ash.Resource.Info.attributes(AshStripe.Subscription)
      attribute_names = Enum.map(attributes, & &1.name)
      
      assert :id in attribute_names
      assert :customer in attribute_names
      assert :status in attribute_names
      assert :current_period_start in attribute_names
      assert :current_period_end in attribute_names
    end
    
    test "has relationship to customer" do
      relationships = Ash.Resource.Info.relationships(AshStripe.Subscription)
      relationship_names = Enum.map(relationships, & &1.name)
      
      assert :stripe_customer in relationship_names
    end
  end
  
  describe "PaymentMethod resource" do
    test "has proper primary key" do
      assert Ash.Resource.Info.primary_key(AshStripe.PaymentMethod) == [:id]
    end
    
    test "has expected attributes" do
      attributes = Ash.Resource.Info.attributes(AshStripe.PaymentMethod)
      attribute_names = Enum.map(attributes, & &1.name)
      
      assert :id in attribute_names
      assert :type in attribute_names
      assert :customer in attribute_names
      assert :card in attribute_names
    end
  end
  
  describe "Product resource" do
    test "has proper primary key" do
      assert Ash.Resource.Info.primary_key(AshStripe.Product) == [:id]
    end
    
    test "has expected attributes" do
      attributes = Ash.Resource.Info.attributes(AshStripe.Product)
      attribute_names = Enum.map(attributes, & &1.name)
      
      assert :id in attribute_names
      assert :name in attribute_names
      assert :active in attribute_names
      assert :description in attribute_names
    end
    
    test "has relationship to prices" do
      relationships = Ash.Resource.Info.relationships(AshStripe.Product)
      relationship_names = Enum.map(relationships, & &1.name)
      
      assert :prices in relationship_names
    end
  end
  
  describe "Price resource" do
    test "has proper primary key" do
      assert Ash.Resource.Info.primary_key(AshStripe.Price) == [:id]
    end
    
    test "has expected attributes" do
      attributes = Ash.Resource.Info.attributes(AshStripe.Price)
      attribute_names = Enum.map(attributes, & &1.name)
      
      assert :id in attribute_names
      assert :currency in attribute_names
      assert :product in attribute_names
      assert :unit_amount in attribute_names
    end
  end
  
  describe "Invoice resource" do
    test "has proper primary key" do
      assert Ash.Resource.Info.primary_key(AshStripe.Invoice) == [:id]
    end
    
    test "has expected attributes" do
      attributes = Ash.Resource.Info.attributes(AshStripe.Invoice)
      attribute_names = Enum.map(attributes, & &1.name)
      
      assert :id in attribute_names
      assert :customer in attribute_names
      assert :subscription in attribute_names
      assert :status in attribute_names
      assert :amount_due in attribute_names
    end
  end
end