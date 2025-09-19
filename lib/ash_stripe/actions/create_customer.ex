defmodule AshStripe.Actions.CreateCustomer do
  @moduledoc """
  Manual action for creating Stripe customers.
  """
  
  use Ash.Resource.ManualCreate
  
  alias AshStripe.Client
  
  @impl true
  def create(changeset, _opts, _context) do
    attributes = Ash.Changeset.get_attributes(changeset)
    
    case Client.create("/v1/customers", attributes) do
      {:ok, result} -> 
        {:ok, struct(changeset.resource, result)}
      {:error, error} -> 
        {:error, error}
    end
  end
end