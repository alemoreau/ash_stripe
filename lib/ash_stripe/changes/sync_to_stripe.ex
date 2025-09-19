defmodule AshStripe.Changes.SyncToStripe do
  @moduledoc """
  A change that syncs resource changes to Stripe.
  
  This change is automatically applied to create, update, and destroy actions
  on Stripe resources to ensure they stay in sync with the Stripe API.
  """
  
  use Ash.Resource.Change
  
  alias AshStripe.Client
  
  @impl true
  def change(changeset, _opts, _context) do
    # The actual sync is handled by the data layer
    # This change exists for extensibility and future enhancements
    changeset
  end
end