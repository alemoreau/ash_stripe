defmodule AshStripe.PaymentIntent do
  @moduledoc """
  Ash resource for Stripe payment intents.
  """
  
  use Ash.Resource,
    domain: AshStripe.Domain

  attributes do
    attribute :id, :string do
      primary_key? true
      allow_nil? false
    end
    
    attribute :object, :string, default: "payment_intent"
    attribute :amount, :integer
    attribute :amount_capturable, :integer
    attribute :amount_details, :map
    attribute :amount_received, :integer
    attribute :application, :string
    attribute :application_fee_amount, :integer
    attribute :automatic_payment_methods, :map
    attribute :canceled_at, :integer
    attribute :cancellation_reason, :string
    attribute :capture_method, :string
    attribute :client_secret, :string
    attribute :confirmation_method, :string
    attribute :created, :integer
    attribute :currency, :string
    attribute :customer, :string
    attribute :description, :string
    attribute :invoice, :string
    attribute :last_payment_error, :map
    attribute :latest_charge, :string
    attribute :livemode, :boolean
    attribute :metadata, :map, default: %{}
    attribute :next_action, :map
    attribute :on_behalf_of, :string
    attribute :payment_method, :string
    attribute :payment_method_configuration_details, :map
    attribute :payment_method_options, :map
    attribute :payment_method_types, {:array, :string}
    attribute :processing, :map
    attribute :receipt_email, :string
    attribute :review, :string
    attribute :setup_future_usage, :string
    attribute :shipping, :map
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
        :amount, :currency, :customer, :description, :payment_method,
        :confirmation_method, :capture_method, :payment_method_types,
        :metadata, :receipt_email, :setup_future_usage, :shipping,
        :statement_descriptor, :statement_descriptor_suffix, :transfer_data,
        :application_fee_amount, :on_behalf_of, :transfer_group
      ]
      manual AshStripe.Actions.CreatePaymentIntent
    end
    
    update :update do
      accept [
        :amount, :currency, :customer, :description, :payment_method,
        :metadata, :receipt_email, :setup_future_usage, :shipping,
        :statement_descriptor, :statement_descriptor_suffix, :transfer_data,
        :application_fee_amount, :transfer_group
      ]
      manual AshStripe.Actions.UpdatePaymentIntent
    end
    
    read :list do
      pagination offset?: true, countable: true, default_limit: 10
      manual AshStripe.Actions.ListPaymentIntents
    end
    
    read :get_by_id do
      argument :id, :string, allow_nil?: false
      get? true
      manual AshStripe.Actions.GetPaymentIntent
    end
    
    read :for_customer do
      argument :customer_id, :string, allow_nil?: false
      manual AshStripe.Actions.ListPaymentIntentsForCustomer
    end
    
    update :confirm do
      accept []
      manual AshStripe.Actions.ConfirmPaymentIntent
    end
    
    update :capture do
      accept [:amount_to_capture]
      manual AshStripe.Actions.CapturePaymentIntent
    end
    
    update :cancel do
      accept [:cancellation_reason]
      manual AshStripe.Actions.CancelPaymentIntent
    end
  end
  
  relationships do
    belongs_to :stripe_customer, AshStripe.Customer do
      source_attribute :customer
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