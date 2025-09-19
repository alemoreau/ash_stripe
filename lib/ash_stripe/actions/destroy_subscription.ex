defmodule AshStripe.Actions.DestroySubscription do
  @moduledoc """
  Manual action for canceling Stripe subscriptions.
  """
  
  use Ash.Resource.ManualDestroy
  
  alias AshStripe.Client
  
  @impl true
  def destroy(changeset, _opts, _context) do
    id = changeset.data.id
    
    case Client.destroy("/v1/subscriptions", id) do
      {:ok, _result} -> 
        :ok
      {:error, error} -> 
        {:error, error}
    end
  end
end