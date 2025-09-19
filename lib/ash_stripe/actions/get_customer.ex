defmodule AshStripe.Actions.GetCustomer do
  @moduledoc """
  Manual action for getting a single Stripe customer by ID.
  """
  
  use Ash.Resource.ManualRead
  
  alias AshStripe.Client
  
  @impl true
  def read(ash_query, _opts, _context) do
    case ash_query.arguments[:id] do
      nil ->
        {:error, "ID argument is required"}
      
      id ->
        case Client.retrieve("/v1/customers", id) do
          {:ok, result} ->
            {:ok, [struct(ash_query.resource, result)]}
          {:error, error} ->
            {:error, error}
        end
    end
  end
end