defmodule AshStripe.Domain do
  @moduledoc """
  The Ash domain for Stripe resources.
  """
  
  use Ash.Domain
  
  resources do
    resource AshStripe.Customer
    resource AshStripe.Subscription
    resource AshStripe.PaymentMethod
  end
end