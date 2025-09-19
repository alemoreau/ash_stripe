defmodule AshStripe.Product do
  @moduledoc """
  Ash resource for Stripe products.
  """
  
  use Ash.Resource,
    domain: AshStripe.Domain
  
  attributes do
    attribute :id, :string do
      primary_key? true
      allow_nil? false
    end
    
    attribute :object, :string, default: "product"
    attribute :active, :boolean
    attribute :attributes, {:array, :string}
    attribute :created, :integer
    attribute :default_price, :string
    attribute :description, :string
    attribute :features, {:array, :map}
    attribute :images, {:array, :string}
    attribute :livemode, :boolean
    attribute :marketing_features, {:array, :map}
    attribute :metadata, :map, default: %{}
    attribute :name, :string
    attribute :package_dimensions, :map
    attribute :shippable, :boolean
    attribute :statement_descriptor, :string
    attribute :tax_code, :string
    attribute :type, :string
    attribute :unit_label, :string
    attribute :updated, :integer
    attribute :url, :string
    
    timestamps()
  end
  
  actions do
    defaults [:read]
    
    create :create do
      accept [
        :name, :active, :description, :features, :images,
        :marketing_features, :metadata, :package_dimensions,
        :shippable, :statement_descriptor, :tax_code, :type,
        :unit_label, :url
      ]
    end
    
    update :update do
      accept [
        :active, :default_price, :description, :features,
        :images, :marketing_features, :metadata, :name,
        :package_dimensions, :shippable, :statement_descriptor,
        :tax_code, :url
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
    
    read :active do
      filter expr(active == true)
    end
    
    read :by_type do
      argument :type, :string, allow_nil?: false
      filter expr(type == ^arg(:type))
    end
  end
  
  relationships do
    has_many :prices, AshStripe.Price do
      source_attribute :id
      destination_attribute :product
    end
    
    belongs_to :default_stripe_price, AshStripe.Price do
      source_attribute :default_price
      destination_attribute :id
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