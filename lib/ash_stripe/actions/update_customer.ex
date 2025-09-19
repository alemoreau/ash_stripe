defmodule AshStripe.Actions.UpdateCustomer do
  @moduledoc """
  Manual action for updating Stripe customers.
  """
  
  use Ash.Resource.ManualUpdate
  
  alias AshStripe.Client
  
  @impl true
  def update(changeset, _opts, _context) do
    attributes = Ash.Changeset.get_attributes(changeset)
    id = changeset.data.id
    
    case Client.update("/v1/customers", id, attributes) do
      {:ok, result} -> 
        {:ok, struct(changeset.resource, result)}
      {:error, error} -> 
        {:error, error}
    end
  end
end