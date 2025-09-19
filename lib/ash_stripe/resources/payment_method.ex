defmodule AshStripe.PaymentMethod do
  @moduledoc """
  Ash resource for Stripe payment methods.
  """
  
  use Ash.Resource,
    domain: AshStripe.Domain
  
  attributes do
    attribute :id, :string do
      primary_key? true
      allow_nil? false
    end
    
    attribute :object, :string, default: "payment_method"
    attribute :allow_redisplay, :string
    attribute :billing_details, :map
    attribute :card, :map
    attribute :created, :integer
    attribute :customer, :string
    attribute :livemode, :boolean
    attribute :metadata, :map, default: %{}
    attribute :type, :string
    attribute :us_bank_account, :map
    attribute :sepa_debit, :map
    attribute :ideal, :map
    attribute :fpx, :map
    attribute :alipay, :map
    attribute :grabpay, :map
    attribute :giropay, :map
    attribute :p24, :map
    attribute :bancontact, :map
    attribute :wechat_pay, :map
    attribute :sofort, :map
    attribute :eps, :map
    attribute :au_becs_debit, :map
    attribute :bacs_debit, :map
    attribute :afterpay_clearpay, :map
    attribute :acss_debit, :map
    attribute :affirm, :map
    attribute :klarna, :map
    attribute :paynow, :map
    attribute :promptpay, :map
    attribute :customer_balance, :map
    attribute :link, :map
    attribute :boleto, :map
    attribute :oxxo, :map
    attribute :konbini, :map
    attribute :cashapp, :map
    
    timestamps()
  end
  
  actions do
    defaults [:read]
    
    create :create do
      accept [
        :type, :customer, :billing_details, :metadata, :allow_redisplay,
        :card, :us_bank_account, :sepa_debit, :ideal, :fpx, :alipay,
        :grabpay, :giropay, :p24, :bancontact, :wechat_pay, :sofort,
        :eps, :au_becs_debit, :bacs_debit, :afterpay_clearpay,
        :acss_debit, :affirm, :klarna, :paynow, :promptpay,
        :customer_balance, :link, :boleto, :oxxo, :konbini, :cashapp
      ]
      manual AshStripe.Actions.CreatePaymentMethod
    end
    
    update :update do
      accept [
        :billing_details, :metadata, :allow_redisplay, :card
      ]
      manual AshStripe.Actions.UpdatePaymentMethod
    end
    
    destroy :destroy do
      manual AshStripe.Actions.DestroyPaymentMethod
    end
    
    read :list do
      pagination offset?: true, countable: true, default_limit: 10
      manual AshStripe.Actions.ListPaymentMethods
    end
    
    read :get_by_id do
      argument :id, :string, allow_nil?: false
      get? true
      manual AshStripe.Actions.GetPaymentMethod
    end
    
    read :for_customer do
      argument :customer_id, :string, allow_nil?: false
      manual AshStripe.Actions.ListPaymentMethodsForCustomer
    end
    
    read :by_type do
      argument :type, :string, allow_nil?: false
      manual AshStripe.Actions.ListPaymentMethodsByType
    end
    
    update :attach do
      argument :customer_id, :string, allow_nil?: false
      manual AshStripe.Actions.AttachPaymentMethod
    end
    
    update :detach do
      manual AshStripe.Actions.DetachPaymentMethod
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