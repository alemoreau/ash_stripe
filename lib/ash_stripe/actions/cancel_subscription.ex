defmodule AshStripe.Actions.CancelSubscription do
  @moduledoc """
  Manual action for canceling Stripe subscriptions at period end.
  """
  
  use Ash.Resource.ManualUpdate
  
  alias AshStripe.Client
  
  @impl true
  def update(changeset, _opts, _context) do
    id = changeset.data.id
    
    # Cancel the subscription at period end
    case Client.update("/v1/subscriptions", id, %{cancel_at_period_end: true}) do
      {:ok, result} -> 
        {:ok, struct(changeset.resource, result)}
      {:error, error} -> 
        {:error, error}
    end
  end
end