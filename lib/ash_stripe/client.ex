defmodule AshStripe.Client do
  @moduledoc """
  HTTP client for interacting with the Stripe API using Req.
  """
  
  @base_url "https://api.stripe.com"
  
  @doc """
  Creates a new Req client configured for Stripe API.
  """
  def new(config \\ AshStripe.config()) do
    Req.new(
      base_url: config.base_url || @base_url,
      headers: [
        {"Authorization", "Bearer #{config.api_key}"},
        {"Stripe-Version", config.api_version},
        {"Content-Type", "application/x-www-form-urlencoded"}
      ]
    )
  end
  
  @doc """
  Makes a GET request to the Stripe API.
  """
  def get(path, params \\ %{}, config \\ AshStripe.config()) do
    client = new(config)
    
    case Req.get(client, url: path, params: params) do
      {:ok, %{status: status, body: body}} when status in 200..299 ->
        {:ok, body}
      {:ok, %{status: status, body: body}} ->
        {:error, %{status: status, body: body}}
      {:error, reason} ->
        {:error, reason}
    end
  end
  
  @doc """
  Makes a POST request to the Stripe API.
  """
  def post(path, body \\ %{}, config \\ AshStripe.config()) do
    client = new(config)
    
    case Req.post(client, url: path, form: body) do
      {:ok, %{status: status, body: response_body}} when status in 200..299 ->
        {:ok, response_body}
      {:ok, %{status: status, body: response_body}} ->
        {:error, %{status: status, body: response_body}}
      {:error, reason} ->
        {:error, reason}
    end
  end
  
  @doc """
  Makes a PUT request to the Stripe API.
  """
  def put(path, body \\ %{}, config \\ AshStripe.config()) do
    client = new(config)
    
    case Req.put(client, url: path, form: body) do
      {:ok, %{status: status, body: response_body}} when status in 200..299 ->
        {:ok, response_body}
      {:ok, %{status: status, body: response_body}} ->
        {:error, %{status: status, body: response_body}}
      {:error, reason} ->
        {:error, reason}
    end
  end
  
  @doc """
  Makes a DELETE request to the Stripe API.
  """
  def delete(path, config \\ AshStripe.config()) do
    client = new(config)
    
    case Req.delete(client, url: path) do
      {:ok, %{status: status, body: body}} when status in 200..299 ->
        {:ok, body}
      {:ok, %{status: status, body: body}} ->
        {:error, %{status: status, body: body}}
      {:error, reason} ->
        {:error, reason}
    end
  end
  
  @doc """
  Lists resources with pagination support.
  """
  def list(path, params \\ %{}, config \\ AshStripe.config()) do
    get(path, params, config)
  end
  
  @doc """
  Retrieves a single resource by ID.
  """
  def retrieve(path, id, params \\ %{}, config \\ AshStripe.config()) do
    get("#{path}/#{id}", params, config)
  end
  
  @doc """
  Creates a new resource.
  """
  def create(path, body, config \\ AshStripe.config()) do
    post(path, body, config)
  end
  
  @doc """
  Updates an existing resource.
  """
  def update(path, id, body, config \\ AshStripe.config()) do
    post("#{path}/#{id}", body, config)
  end
  
  @doc """
  Deletes a resource.
  """
  def destroy(path, id, config \\ AshStripe.config()) do
    delete("#{path}/#{id}", config)
  end
end