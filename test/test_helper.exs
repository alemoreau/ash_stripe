ExUnit.start()

defmodule AshStripe.TestCase do
  use ExUnit.CaseTemplate
  
  using do
    quote do
      use ExUnit.Case
      import AshStripe.TestCase
    end
  end
end