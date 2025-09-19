defmodule AshStripe.Invoice do
  @moduledoc """
  Ash resource for Stripe invoices.
  """
  
  use Ash.Resource,
    domain: AshStripe.Domain,
    data_layer: {AshStripe.DataLayer, endpoint: "/v1/invoices"}
  
  attributes do
    attribute :id, :string do
      primary_key? true
      allow_nil? false
    end
    
    attribute :object, :string, default: "invoice"
    attribute :account_country, :string
    attribute :account_name, :string
    attribute :account_tax_ids, {:array, :string}
    attribute :amount_due, :integer
    attribute :amount_paid, :integer
    attribute :amount_remaining, :integer
    attribute :application, :string
    attribute :application_fee_amount, :integer
    attribute :attempt_count, :integer
    attribute :attempted, :boolean
    attribute :auto_advance, :boolean
    attribute :automatic_tax, :map
    attribute :billing_reason, :string
    attribute :charge, :string
    attribute :collection_method, :string
    attribute :created, :integer
    attribute :currency, :string
    attribute :custom_fields, {:array, :map}
    attribute :customer, :string
    attribute :customer_address, :map
    attribute :customer_email, :string
    attribute :customer_name, :string
    attribute :customer_phone, :string
    attribute :customer_shipping, :map
    attribute :customer_tax_exempt, :string
    attribute :customer_tax_ids, {:array, :map}
    attribute :default_payment_method, :string
    attribute :default_source, :string
    attribute :default_tax_rates, {:array, :map}
    attribute :description, :string
    attribute :discount, :map
    attribute :discounts, {:array, :string}
    attribute :due_date, :integer
    attribute :effective_at, :integer
    attribute :ending_balance, :integer
    attribute :footer, :string
    attribute :from_invoice, :map
    attribute :hosted_invoice_url, :string
    attribute :invoice_pdf, :string
    attribute :issuer, :map
    attribute :last_finalization_error, :map
    attribute :latest_revision, :string
    attribute :lines, :map
    attribute :livemode, :boolean
    attribute :metadata, :map, default: %{}
    attribute :next_payment_attempt, :integer
    attribute :number, :string
    attribute :on_behalf_of, :string
    attribute :paid, :boolean
    attribute :paid_out_of_band, :boolean
    attribute :payment_intent, :string
    attribute :payment_settings, :map
    attribute :period_end, :integer
    attribute :period_start, :integer
    attribute :post_payment_credit_notes_amount, :integer
    attribute :pre_payment_credit_notes_amount, :integer
    attribute :quote, :string
    attribute :receipt_number, :string
    attribute :rendering, :map
    attribute :rendering_options, :map
    attribute :shipping_cost, :map
    attribute :shipping_details, :map
    attribute :starting_balance, :integer
    attribute :statement_descriptor, :string
    attribute :status, :string
    attribute :status_transitions, :map
    attribute :subscription, :string
    attribute :subscription_details, :map
    attribute :subtotal, :integer
    attribute :subtotal_excluding_tax, :integer
    attribute :tax, :integer
    attribute :test_clock, :string
    attribute :total, :integer
    attribute :total_discount_amounts, {:array, :map}
    attribute :total_excluding_tax, :integer
    attribute :total_tax_amounts, {:array, :map}
    attribute :transfer_data, :map
    attribute :webhooks_delivered_at, :integer
    
    timestamps()
  end
  
  actions do
    defaults [:read]
    
    create :create do
      accept [
        :customer, :auto_advance, :collection_method, :currency,
        :custom_fields, :description, :discounts, :due_date,
        :footer, :metadata, :on_behalf_of, :payment_settings,
        :rendering_options, :statement_descriptor, :subscription
      ]
    end
    
    update :update do
      accept [
        :auto_advance, :collection_method, :custom_fields, 
        :description, :discounts, :due_date, :footer,
        :metadata, :on_behalf_of, :payment_settings,
        :rendering_options, :statement_descriptor
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
    
    read :for_subscription do
      argument :subscription_id, :string, allow_nil?: false
      filter expr(subscription == ^arg(:subscription_id))
    end
    
    update :finalize do
      accept []
    end
    
    update :pay do
      accept []
    end
    
    update :send_invoice do
      accept []
    end
    
    update :void do
      accept []
    end
  end
  
  relationships do
    belongs_to :stripe_customer, AshStripe.Customer do
      source_attribute :customer
      destination_attribute :id
    end
    
    belongs_to :stripe_subscription, AshStripe.Subscription do
      source_attribute :subscription
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