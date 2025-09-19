defmodule AshStripe.Subscription do
  @moduledoc """
  Ash resource for Stripe subscriptions.
  """
  
  use Ash.Resource,
    domain: AshStripe.Domain,
    data_layer: {AshStripe.DataLayer, endpoint: "/v1/subscriptions"}
  
  attributes do
    attribute :id, :string do
      primary_key? true
      allow_nil? false
    end
    
    attribute :object, :string, default: "subscription"
    attribute :application, :string
    attribute :application_fee_percent, :decimal
    attribute :automatic_tax, :map
    attribute :billing_cycle_anchor, :integer
    attribute :billing_thresholds, :map
    attribute :cancel_at, :integer
    attribute :cancel_at_period_end, :boolean
    attribute :canceled_at, :integer
    attribute :cancellation_details, :map
    attribute :collection_method, :string
    attribute :created, :integer
    attribute :currency, :string
    attribute :current_period_end, :integer
    attribute :current_period_start, :integer
    attribute :customer, :string
    attribute :days_until_due, :integer
    attribute :default_payment_method, :string
    attribute :default_source, :string
    attribute :default_tax_rates, {:array, :map}
    attribute :description, :string
    attribute :discount, :map
    attribute :ended_at, :integer
    attribute :invoice_settings, :map
    attribute :items, :map
    attribute :latest_invoice, :string
    attribute :livemode, :boolean
    attribute :metadata, :map, default: %{}
    attribute :next_pending_invoice_item_invoice, :integer
    attribute :on_behalf_of, :string
    attribute :pause_collection, :map
    attribute :payment_settings, :map
    attribute :pending_invoice_item_interval, :map
    attribute :pending_setup_intent, :string
    attribute :pending_update, :map
    attribute :schedule, :string
    attribute :start_date, :integer
    attribute :status, :string
    attribute :test_clock, :string
    attribute :transfer_data, :map
    attribute :trial_end, :integer
    attribute :trial_settings, :map
    attribute :trial_start, :integer
    
    timestamps()
  end
  
  actions do
    defaults [:read]
    
    create :create do
      accept [
        :customer, :automatic_tax, :billing_cycle_anchor, :billing_thresholds,
        :cancel_at, :cancel_at_period_end, :collection_method, :currency,
        :days_until_due, :default_payment_method, :default_source,
        :default_tax_rates, :description, :invoice_settings, :items,
        :metadata, :on_behalf_of, :payment_settings, :pending_invoice_item_interval,
        :transfer_data, :trial_end, :trial_settings
      ]
    end
    
    update :update do
      accept [
        :automatic_tax, :billing_cycle_anchor, :billing_thresholds,
        :cancel_at, :cancel_at_period_end, :collection_method,
        :days_until_due, :default_payment_method, :default_source,
        :default_tax_rates, :description, :invoice_settings,
        :metadata, :on_behalf_of, :payment_settings, :pending_invoice_item_interval,
        :transfer_data, :trial_end, :trial_settings
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
    
    read :for_customer do
      argument :customer_id, :string, allow_nil?: false
      filter expr(customer == ^arg(:customer_id))
    end
    
    update :cancel do
      accept []
      change fn changeset, _context ->
        Ash.Changeset.change_attribute(changeset, :cancel_at_period_end, true)
      end
    end
  end
  
  relationships do
    belongs_to :stripe_customer, AshStripe.Customer do
      source_attribute :customer
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