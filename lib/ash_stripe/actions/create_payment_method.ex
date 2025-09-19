defmodule AshStripe.Actions.CreatePaymentMethod do
  @moduledoc """
  Manual action for creating Stripe payment methods.
  """
  
  use Ash.Resource.ManualCreate
  
  alias AshStripe.Client
  
  @impl true
  def create(changeset, _opts, _context) do
    attributes = Ash.Changeset.get_attributes(changeset)
    
    case Client.create("/v1/payment_methods", attributes) do
      {:ok, result} -> 
        {:ok, struct(changeset.resource, result)}
      {:error, error} -> 
        {:error, error}
    end
  end
end