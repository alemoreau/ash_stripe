defmodule AshStripe.Extensions.Product.StripeProduct do
  @moduledoc false
  defstruct [:attribute, :relationship_name, :allow_nil?]
end

defmodule AshStripe.Extensions.Product.StripePrice do
  @moduledoc false
  defstruct [:attribute, :relationship_name, :allow_nil?]
end