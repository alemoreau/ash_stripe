defmodule AshStripe.Preparations.LoadFromStripe do
  @moduledoc """
  A preparation that loads data from Stripe.
  
  This preparation is automatically applied to read actions on Stripe resources
  to fetch the latest data from the Stripe API.
  """
  
  use Ash.Resource.Preparation
  
  @impl true
  def prepare(query, _opts, _context) do
    # The actual loading is handled by the data layer
    # This preparation exists for extensibility and future enhancements
    query
  end
end