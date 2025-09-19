defmodule AshStripe.Extensions.Subscription.StripeSubscription do
  @moduledoc false
  defstruct [:attribute, :relationship_name, :allow_nil?]
end

defmodule AshStripe.Extensions.Subscription.StripeCustomer do
  @moduledoc false
  defstruct [:attribute, :relationship_name, :allow_nil?]
end