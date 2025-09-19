defmodule AshStripe.Charge do
  @moduledoc """
  Ash resource for Stripe charges.
  """
  
  use Ash.Resource,
    domain: AshStripe.Domain

  attributes do
    attribute :id, :string do
      primary_key? true
      allow_nil? false
    end
    
    attribute :object, :string, default: "charge"
    attribute :amount, :integer
    attribute :amount_captured, :integer
    attribute :amount_refunded, :integer
    attribute :application, :string
    attribute :application_fee, :string
    attribute :application_fee_amount, :integer
    attribute :balance_transaction, :string
    attribute :billing_details, :map
    attribute :calculated_statement_descriptor, :string
    attribute :captured, :boolean
    attribute :created, :integer
    attribute :currency, :string
    attribute :customer, :string
    attribute :description, :string
    attribute :destination, :string
    attribute :dispute, :string
    attribute :disputed, :boolean
    attribute :failure_balance_transaction, :string
    attribute :failure_code, :string
    attribute :failure_message, :string
    attribute :fraud_details, :map
    attribute :invoice, :string
    attribute :livemode, :boolean
    attribute :metadata, :map, default: %{}
    attribute :on_behalf_of, :string
    attribute :outcome, :map
    attribute :paid, :boolean
    attribute :payment_intent, :string
    attribute :payment_method, :string
    attribute :payment_method_details, :map
    attribute :receipt_email, :string
    attribute :receipt_number, :string
    attribute :receipt_url, :string
    attribute :refunded, :boolean
    attribute :refunds, :map
    attribute :review, :string
    attribute :shipping, :map
    attribute :source, :map
    attribute :source_transfer, :string
    attribute :statement_descriptor, :string
    attribute :statement_descriptor_suffix, :string
    attribute :status, :string
    attribute :transfer_data, :map
    attribute :transfer_group, :string
    
    timestamps()
  end
  
  actions do
    create :create do
      accept [
        :amount, :currency, :customer, :description, :metadata,
        :receipt_email, :shipping, :source, :statement_descriptor,
        :statement_descriptor_suffix, :application_fee_amount,
        :capture, :on_behalf_of, :transfer_data, :transfer_group
      ]
      manual AshStripe.Actions.CreateCharge
    end
    
    update :update do
      accept [
        :customer, :description, :metadata, :receipt_email,
        :shipping, :transfer_group
      ]
      manual AshStripe.Actions.UpdateCharge
    end
    
    read :list do
      pagination offset?: true, countable: true, default_limit: 10
      manual AshStripe.Actions.ListCharges
    end
    
    read :get_by_id do
      argument :id, :string, allow_nil?: false
      get? true
      manual AshStripe.Actions.GetCharge
    end
    
    read :for_customer do
      argument :customer_id, :string, allow_nil?: false
      manual AshStripe.Actions.ListChargesForCustomer
    end
    
    update :capture do
      accept [:amount, :receipt_email, :statement_descriptor, :statement_descriptor_suffix]
      manual AshStripe.Actions.CaptureCharge
    end
  end
  
  relationships do
    belongs_to :stripe_customer, AshStripe.Customer do
      source_attribute :customer
      destination_attribute :id
    end
    
    belongs_to :stripe_payment_intent, AshStripe.PaymentIntent do
      source_attribute :payment_intent
      destination_attribute :id
    end
    
    belongs_to :stripe_payment_method, AshStripe.PaymentMethod do
      source_attribute :payment_method
      destination_attribute :id
    end
    
    belongs_to :stripe_invoice, AshStripe.Invoice do
      source_attribute :invoice
      destination_attribute :id
    end
  end
  
  identities do
    identity :unique_id, [:id]
  end
end