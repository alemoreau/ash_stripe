defmodule AshStripe.Price do
  @moduledoc """
  Ash resource for Stripe prices.
  """
  
  use Ash.Resource,
    domain: AshStripe.Domain,
    data_layer: {AshStripe.DataLayer, endpoint: "/v1/prices"}
  
  attributes do
    attribute :id, :string do
      primary_key? true
      allow_nil? false
    end
    
    attribute :object, :string, default: "price"
    attribute :active, :boolean
    attribute :billing_scheme, :string
    attribute :created, :integer
    attribute :currency, :string
    attribute :currency_options, :map
    attribute :custom_unit_amount, :map
    attribute :livemode, :boolean
    attribute :lookup_key, :string
    attribute :metadata, :map, default: %{}
    attribute :nickname, :string
    attribute :product, :string
    attribute :recurring, :map
    attribute :tax_behavior, :string
    attribute :tiers, {:array, :map}
    attribute :tiers_mode, :string
    attribute :transform_quantity, :map
    attribute :type, :string
    attribute :unit_amount, :integer
    attribute :unit_amount_decimal, :string
    
    timestamps()
  end
  
  actions do
    defaults [:read]
    
    create :create do
      accept [
        :currency, :product, :active, :billing_scheme,
        :currency_options, :custom_unit_amount, :lookup_key,
        :metadata, :nickname, :recurring, :tax_behavior,
        :tiers, :tiers_mode, :transform_quantity, :type,
        :unit_amount, :unit_amount_decimal
      ]
    end
    
    update :update do
      accept [
        :active, :currency_options, :lookup_key, :metadata,
        :nickname, :tax_behavior, :transfer_lookup_key
      ]
    end
    
    read :list do
      pagination offset?: true, countable: true, default_limit: 10
    end
    
    read :get_by_id do
      argument :id, :string, allow_nil?: false
      get? true
    end
    
    read :for_product do
      argument :product_id, :string, allow_nil?: false
      filter expr(product == ^arg(:product_id))
    end
    
    read :active do
      filter expr(active == true)
    end
    
    read :by_lookup_key do
      argument :lookup_key, :string, allow_nil?: false
      filter expr(lookup_key == ^arg(:lookup_key))
    end
  end
  
  relationships do
    belongs_to :stripe_product, AshStripe.Product do
      source_attribute :product
      destination_attribute :id
    end
  end
  
  preparations do
    prepare AshStripe.Preparations.LoadFromStripe
  end
  
  changes do
    change AshStripe.Changes.SyncToStripe, on: [:create, :update]
  end
  
  identities do
    identity :unique_id, [:id]
    identity :unique_lookup_key, [:lookup_key]
  end
end