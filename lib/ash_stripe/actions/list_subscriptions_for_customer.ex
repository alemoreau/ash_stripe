defmodule AshStripe.Actions.ListSubscriptionsForCustomer do
  @moduledoc """
  Manual action for listing Stripe subscriptions for a specific customer.
  """
  
  use Ash.Resource.ManualRead
  
  alias AshStripe.Client
  
  @impl true
  def read(ash_query, _opts, _context) do
    case ash_query.arguments[:customer_id] do
      nil ->
        {:error, "customer_id argument is required"}
      
      customer_id ->
        params = %{customer: customer_id}
        params = build_params(ash_query, params)
        
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
  end
  
  defp build_params(ash_query, params) do
    # Handle pagination
    params = if ash_query.limit, do: Map.put(params, :limit, ash_query.limit), else: params
    
    # Handle offset as starting_after (Stripe's cursor pagination)
    params = if ash_query.offset, do: Map.put(params, :starting_after, ash_query.offset), else: params
    
    params
  end
end