defmodule AshStripe.Actions.DestroyCustomer do
  @moduledoc """
  Manual action for deleting Stripe customers.
  """
  
  use Ash.Resource.ManualDestroy
  
  alias AshStripe.Client
  
  @impl true
  def destroy(changeset, _opts, _context) do
    id = changeset.data.id
    
    case Client.destroy("/v1/customers", id) do
      {:ok, _result} -> 
        :ok
      {:error, error} -> 
        {:error, error}
    end
  end
end