defmodule AshStripe.Extensions.Customer.StripeCustomer do
  @moduledoc false
  defstruct [:attribute, :relationship_name, :allow_nil?]
end

defmodule AshStripe.Extensions.Customer.StripeSubscription do
  @moduledoc false
  defstruct [:attribute, :relationship_name, :allow_nil?]
end

defmodule AshStripe.Extensions.Customer.StripePaymentMethod do
  @moduledoc false
  defstruct [:attribute, :relationship_name, :allow_nil?]
end

defmodule AshStripe.Extensions.Customer.StripeInvoice do
  @moduledoc false
  defstruct [:attribute, :relationship_name, :allow_nil?]
end