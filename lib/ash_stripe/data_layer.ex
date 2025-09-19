defmodule AshStripe.DataLayer do
  @moduledoc """
  A data layer for Ash resources that interact with the Stripe API.
  
  This data layer handles reading from and writing to Stripe via HTTP requests.
  """
  
  @behaviour Ash.DataLayer
  
  alias AshStripe.Client
  
  @impl true
  def can?(_, :read), do: true
  def can?(_, :create), do: true
  def can?(_, :update), do: true
  def can?(_, :destroy), do: true
  def can?(_, :filter), do: true
  def can?(_, :sort), do: true
  def can?(_, :limit), do: true
  def can?(_, :offset), do: true
  def can?(_, _), do: false
  
  @impl true
  def resource_to_query(resource, domain) do
    %__MODULE__.Query{
      resource: resource,
      domain: domain,
      endpoint: get_endpoint(resource),
      filter: nil,
      sort: [],
      limit: nil,
      offset: nil
    }
  end
  
  @impl true
  def limit(query, limit, _) do
    {:ok, %{query | limit: limit}}
  end
  
  @impl true
  def offset(query, offset, _) do
    {:ok, %{query | offset: offset}}
  end
  
  @impl true
  def filter(query, filter, _resource) do
    {:ok, %{query | filter: filter}}
  end
  
  @impl true
  def sort(query, sort, _resource) do
    {:ok, %{query | sort: sort}}
  end
  
  @impl true
  def run_query(query, resource) do
    case query.action_type do
      :read -> handle_read(query, resource)
      :create -> handle_create(query, resource)
      :update -> handle_update(query, resource)
      :destroy -> handle_destroy(query, resource)
    end
  end
  
  @impl true
  def create(resource, changeset) do
    endpoint = get_endpoint(resource)
    attributes = Ash.Changeset.get_attributes(changeset)
    
    case Client.create(endpoint, attributes) do
      {:ok, result} -> {:ok, struct(resource, result)}
      {:error, error} -> {:error, error}
    end
  end
  
  @impl true
  def update(resource, changeset) do
    endpoint = get_endpoint(resource)
    id = Ash.Resource.Info.primary_key_value(changeset.data)
    attributes = Ash.Changeset.get_attributes(changeset)
    
    case Client.update(endpoint, id, attributes) do
      {:ok, result} -> {:ok, struct(resource, result)}
      {:error, error} -> {:error, error}
    end
  end
  
  @impl true
  def destroy(resource, changeset) do
    endpoint = get_endpoint(resource)
    id = Ash.Resource.Info.primary_key_value(changeset.data)
    
    case Client.destroy(endpoint, id) do
      {:ok, _result} -> :ok
      {:error, error} -> {:error, error}
    end
  end
  
  @impl true
  def transaction(resource, func, timeout) do
    # Stripe API doesn't support transactions, so we just run the function
    func.()
  end
  
  @impl true
  def rollback(_resource, _value) do
    # No rollback support for Stripe API
    :ok
  end
  
  defmodule Query do
    @moduledoc false
    defstruct [:resource, :domain, :endpoint, :filter, :sort, :limit, :offset, :action_type]
  end
  
  # Private functions
  
  defp handle_read(query, resource) do
    params = build_params(query)
    
    case Client.list(query.endpoint, params) do
      {:ok, %{"data" => data}} ->
        records = Enum.map(data, &struct(resource, &1))
        {:ok, records}
      {:ok, result} when is_map(result) ->
        {:ok, [struct(resource, result)]}
      {:error, error} ->
        {:error, error}
    end
  end
  
  defp handle_create(_query, _resource) do
    # This should not be called as we implement create/2
    {:error, "Create should use create/2"}
  end
  
  defp handle_update(_query, _resource) do
    # This should not be called as we implement update/2
    {:error, "Update should use update/2"}
  end
  
  defp handle_destroy(_query, _resource) do
    # This should not be called as we implement destroy/2
    {:error, "Destroy should use destroy/2"}
  end
  
  defp build_params(query) do
    params = %{}
    
    params = if query.limit, do: Map.put(params, :limit, query.limit), else: params
    params = if query.offset, do: Map.put(params, :starting_after, query.offset), else: params
    
    params
  end
  
  defp get_endpoint(resource) do
    case Ash.Resource.Info.data_layer(resource) do
      {AshStripe.DataLayer, opts} when is_list(opts) ->
        opts[:endpoint] || raise "No endpoint configured for #{resource}"
      AshStripe.DataLayer ->
        raise "No endpoint configured for #{resource}"
      _ ->
        raise "Invalid data layer for #{resource}"
    end
  end
end