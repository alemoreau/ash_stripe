defmodule Example.Organization do
  @moduledoc """
  Example organization resource that integrates with Stripe.
  """
  
  use Ash.Resource,
    domain: Example.Domain,
    extensions: [AshStripe.Extensions.Customer]
  
  stripe_customer do
    stripe_customer :stripe_customer_id
    stripe_subscription :stripe_subscription_id
    stripe_invoice :stripe_invoice_id
  end
  
  attributes do
    uuid_primary_key :id
    attribute :name, :string, allow_nil?: false
    attribute :email, :string
    attribute :stripe_customer_id, :string
    attribute :stripe_subscription_id, :string
    attribute :stripe_invoice_id, :string
    
    timestamps()
  end
  
  actions do
    defaults [:create, :read, :update, :destroy]
    
    create :create_with_stripe do
      accept [:name, :email]
      
      change fn changeset, _context ->
        # This would typically create a Stripe customer
        # and set the stripe_customer_id
        changeset
      end
    end
  end
  
  relationships do
    # The AshStripe.Extensions.Customer extension automatically adds:
    # belongs_to :stripe_customer, AshStripe.Customer
    # belongs_to :stripe_subscription, AshStripe.Subscription  
    # belongs_to :stripe_invoice, AshStripe.Invoice
  end
end

defmodule Example.Domain do
  @moduledoc """
  Example domain that includes both local and Stripe resources.
  """
  
  use Ash.Domain
  
  resources do
    resource Example.Organization
    # Include Stripe resources
    resource AshStripe.Customer
    resource AshStripe.Subscription
    resource AshStripe.PaymentMethod
    resource AshStripe.Invoice
    resource AshStripe.Product
    resource AshStripe.Price
  end
end