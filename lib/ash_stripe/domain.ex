defmodule AshStripe.Domain do
  @moduledoc """
  The Ash domain for Stripe resources.
  """
  
  use Ash.Domain
  
  resources do
    resource AshStripe.Customer
    resource AshStripe.Subscription
    resource AshStripe.PaymentMethod
    resource AshStripe.Invoice
    resource AshStripe.Product
    resource AshStripe.Price
  end
end