defmodule AshStripe.Config do
  @moduledoc """
  Configuration for AshStripe.
  """
  
  @doc """
  Gets the Stripe API key from configuration.
  """
  def api_key do
    Application.get_env(:ash_stripe, :api_key) ||
      System.get_env("STRIPE_SECRET_KEY") ||
      raise "No Stripe API key configured. Set :ash_stripe, :api_key or STRIPE_SECRET_KEY environment variable."
  end
  
  @doc """
  Gets the Stripe API version from configuration.
  """
  def api_version do
    Application.get_env(:ash_stripe, :api_version, "2025-02-24.acacia")
  end
  
  @doc """
  Gets the base URL for Stripe API.
  """
  def base_url do
    Application.get_env(:ash_stripe, :base_url, "https://api.stripe.com")
  end
end