defmodule AshStripe.Extension.StripeCustomer do
  @moduledoc false
  defstruct [:attribute, :relationship_name, :allow_nil?]
end

defmodule AshStripe.Extension.StripeSubscription do
  @moduledoc false
  defstruct [:attribute, :relationship_name, :allow_nil?]
end

defmodule AshStripe.Extension.StripePaymentMethod do
  @moduledoc false
  defstruct [:attribute, :relationship_name, :allow_nil?]
end

defmodule AshStripe.Extension.StripeInvoice do
  @moduledoc false
  defstruct [:attribute, :relationship_name, :allow_nil?]
end

defmodule AshStripe.Extension.StripeProduct do
  @moduledoc false
  defstruct [:attribute, :relationship_name, :allow_nil?]
end

defmodule AshStripe.Extension.StripePrice do
  @moduledoc false
  defstruct [:attribute, :relationship_name, :allow_nil?]
end