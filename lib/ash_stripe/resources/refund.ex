defmodule AshStripe.Refund do
  @moduledoc """
  Ash resource for Stripe refunds.
  """
  
  use Ash.Resource,
    domain: AshStripe.Domain

  attributes do
    attribute :id, :string do
      primary_key? true
      allow_nil? false
    end
    
    attribute :object, :string, default: "refund"
    attribute :amount, :integer
    attribute :balance_transaction, :string
    attribute :charge, :string
    attribute :created, :integer
    attribute :currency, :string
    attribute :description, :string
    attribute :failure_balance_transaction, :string
    attribute :failure_reason, :string
    attribute :instructions_email, :string
    attribute :metadata, :map, default: %{}
    attribute :next_action, :map
    attribute :payment_intent, :string
    attribute :reason, :string
    attribute :receipt_number, :string
    attribute :source_transfer_reversal, :string
    attribute :status, :string
    attribute :transfer_reversal, :string
    
    timestamps()
  end
  
  actions do
    create :create do
      accept [
        :charge, :amount, :payment_intent, :reason, :refund_application_fee,
        :reverse_transfer, :metadata, :instructions_email
      ]
      manual AshStripe.Actions.CreateRefund
    end
    
    update :update do
      accept [:metadata]
      manual AshStripe.Actions.UpdateRefund
    end
    
    read :list do
      pagination offset?: true, countable: true, default_limit: 10
      manual AshStripe.Actions.ListRefunds
    end
    
    read :get_by_id do
      argument :id, :string, allow_nil?: false
      get? true
      manual AshStripe.Actions.GetRefund
    end
    
    read :for_charge do
      argument :charge_id, :string, allow_nil?: false
      manual AshStripe.Actions.ListRefundsForCharge
    end
    
    update :cancel do
      accept []
      manual AshStripe.Actions.CancelRefund
    end
  end
  
  relationships do
    belongs_to :stripe_payment_intent, AshStripe.PaymentIntent do
      source_attribute :payment_intent
      destination_attribute :id
    end
  end
  
  identities do
    identity :unique_id, [:id]
  end
end