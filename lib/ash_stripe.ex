defmodule AshStripe do
  @moduledoc """
  An Ash extension for integrating Stripe with your Ash applications.
  
  ## Usage
  
  To use AshStripe in your application, you need to:
  
  1. Configure your Stripe API key
  2. Use the extension in your Ash domain
  3. Define relationships to Stripe resources
  
  ## Configuration
  
      config :ash_stripe,
        api_key: System.get_env("STRIPE_SECRET_KEY"),
        api_version: "2025-02-24.acacia"
  
  ## Example
  
      defmodule MyApp.Organization do
        use Ash.Resource,
          domain: MyApp.Domain,
          extensions: [AshStripe]
        
        ash_stripe do
          stripe_customer :customer
        end
        
        attributes do
          uuid_primary_key :id
          attribute :name, :string
        end
        
        relationships do
          belongs_to :customer, AshStripe.Customer
        end
      end
  """
  
  defstruct [:api_key, :api_version, :base_url]
  
  @default_api_version "2025-02-24.acacia"
  @base_url "https://api.stripe.com"
  
  @doc """
  Creates a new AshStripe configuration.
  """
  def new(opts \\ []) do
    %__MODULE__{
      api_key: opts[:api_key] || AshStripe.Config.api_key(),
      api_version: opts[:api_version] || AshStripe.Config.api_version(),
      base_url: opts[:base_url] || AshStripe.Config.base_url()
    }
  end
  
  @doc """
  Gets the default configuration.
  """
  def config do
    new()
  end
end