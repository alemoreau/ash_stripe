defmodule AshStripe.Customer do
  @moduledoc """
  Ash resource for Stripe customers.
  
  This resource wraps the Stripe Customer API and provides all standard CRUD operations.
  """
  
  use Ash.Resource,
    domain: AshStripe.Domain,
    data_layer: {AshStripe.DataLayer, endpoint: "/v1/customers"}
  
  attributes do
    attribute :id, :string do
      primary_key? true
      allow_nil? false
    end
    
    attribute :object, :string, default: "customer"
    attribute :created, :integer
    attribute :currency, :string
    attribute :default_source, :string
    attribute :delinquent, :boolean
    attribute :description, :string
    attribute :email, :string
    attribute :invoice_prefix, :string
    attribute :livemode, :boolean
    attribute :name, :string
    attribute :next_invoice_sequence, :integer
    attribute :phone, :string
    attribute :preferred_locales, {:array, :string}
    attribute :tax_exempt, :string
    
    # Address attributes
    attribute :address, :map do
      constraints keys: [
        city: [type: :string],
        country: [type: :string],
        line1: [type: :string],
        line2: [type: :string],
        postal_code: [type: :string],
        state: [type: :string]
      ]
    end
    
    # Shipping attributes
    attribute :shipping, :map do
      constraints keys: [
        address: [type: :map],
        name: [type: :string],
        phone: [type: :string]
      ]
    end
    
    # Metadata
    attribute :metadata, :map, default: %{}
    
    # Balance and discount
    attribute :balance, :integer
    attribute :discount, :map
    
    # Tax info
    attribute :tax, :map
    
    # Test clock
    attribute :test_clock, :string
    
    timestamps()
  end
  
  actions do
    defaults [:read]
    
    create :create do
      accept [
        :email, :name, :phone, :description, :address, :shipping,
        :metadata, :preferred_locales, :tax_exempt
      ]
    end
    
    update :update do
      accept [
        :email, :name, :phone, :description, :address, :shipping,
        :metadata, :preferred_locales, :tax_exempt
      ]
    end
    
    destroy :destroy
    
    read :list do
      pagination offset?: true, countable: true, default_limit: 10
    end
    
    read :get_by_id do
      argument :id, :string, allow_nil?: false
      get? true
    end
  end
  
  preparations do
    prepare AshStripe.Preparations.LoadFromStripe
  end
  
  changes do
    change AshStripe.Changes.SyncToStripe, on: [:create, :update, :destroy]
  end
  
  identities do
    identity :unique_id, [:id]
  end
end