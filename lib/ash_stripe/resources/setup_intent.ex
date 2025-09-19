defmodule AshStripe.SetupIntent do
  @moduledoc """
  Ash resource for Stripe setup intents.
  """
  
  use Ash.Resource,
    domain: AshStripe.Domain

  attributes do
    attribute :id, :string do
      primary_key? true
      allow_nil? false
    end
    
    attribute :object, :string, default: "setup_intent"
    attribute :application, :string
    attribute :automatic_payment_methods, :map
    attribute :cancellation_reason, :string
    attribute :client_secret, :string
    attribute :created, :integer
    attribute :customer, :string
    attribute :description, :string
    attribute :flow_directions, {:array, :string}
    attribute :last_setup_error, :map
    attribute :latest_attempt, :string
    attribute :livemode, :boolean
    attribute :mandate, :string
    attribute :metadata, :map, default: %{}
    attribute :next_action, :map
    attribute :on_behalf_of, :string
    attribute :payment_method, :string
    attribute :payment_method_configuration_details, :map
    attribute :payment_method_options, :map
    attribute :payment_method_types, {:array, :string}
    attribute :single_use_mandate, :string
    attribute :status, :string
    attribute :usage, :string
    
    timestamps()
  end
  
  actions do
    create :create do
      accept [
        :customer, :description, :payment_method, :payment_method_types,
        :usage, :metadata, :on_behalf_of, :flow_directions
      ]
      manual AshStripe.Actions.CreateSetupIntent
    end
    
    update :update do
      accept [
        :customer, :description, :payment_method, :metadata,
        :payment_method_types
      ]
      manual AshStripe.Actions.UpdateSetupIntent
    end
    
    read :list do
      pagination offset?: true, countable: true, default_limit: 10
      manual AshStripe.Actions.ListSetupIntents
    end
    
    read :get_by_id do
      argument :id, :string, allow_nil?: false
      get? true
      manual AshStripe.Actions.GetSetupIntent
    end
    
    read :for_customer do
      argument :customer_id, :string, allow_nil?: false
      manual AshStripe.Actions.ListSetupIntentsForCustomer
    end
    
    update :confirm do
      accept [:payment_method, :return_url]
      manual AshStripe.Actions.ConfirmSetupIntent
    end
    
    update :cancel do
      accept [:cancellation_reason]
      manual AshStripe.Actions.CancelSetupIntent
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
  end
  
  identities do
    identity :unique_id, [:id]
  end
end