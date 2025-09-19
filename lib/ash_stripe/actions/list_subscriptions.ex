defmodule AshStripe.Actions.ListSubscriptions do
  @moduledoc """
  Manual action for listing Stripe subscriptions.
  """
  
  use Ash.Resource.ManualRead
  
  alias AshStripe.Client
  
  @impl true
  def read(ash_query, _opts, _context) do
    params = build_params(ash_query)
    
    case Client.list("/v1/subscriptions", params) do
      {:ok, %{"data" => data}} ->
        records = Enum.map(data, &struct(ash_query.resource, &1))
        {:ok, records}
      {:ok, result} when is_map(result) ->
        {:ok, [struct(ash_query.resource, result)]}
      {:error, error} ->
        {:error, error}
    end
  end
  
  defp build_params(ash_query) do
    params = %{}
    
    # Handle pagination
    params = if ash_query.limit, do: Map.put(params, :limit, ash_query.limit), else: params
    
    # Handle offset as starting_after (Stripe's cursor pagination)
    params = if ash_query.offset, do: Map.put(params, :starting_after, ash_query.offset), else: params
    
    params
  end
end