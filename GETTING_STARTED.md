# Getting Started with AshStripe

This guide will walk you through setting up and using AshStripe in your application.

## Installation

1. Add `ash_stripe` to your `mix.exs` dependencies:

```elixir
def deps do
  [
    {:ash_stripe, "~> 0.1.0"},
    {:ash, "~> 3.0"},
    {:req, "~> 0.4"}
  ]
end
```

2. Run `mix deps.get` to fetch the dependencies.

## Configuration

Set up your Stripe API credentials in your config files:

```elixir
# config/config.exs
config :ash_stripe,
  api_key: System.get_env("STRIPE_SECRET_KEY"),
  api_version: "2025-02-24.acacia"

# For different environments:
# config/dev.exs - use test keys
# config/prod.exs - use live keys
```

Or set the `STRIPE_SECRET_KEY` environment variable.

## Basic Usage

### 1. Add Stripe Resources to Your Domain

```elixir
defmodule MyApp.Domain do
  use Ash.Domain

  resources do
    # Your existing resources
    resource MyApp.User
    resource MyApp.Organization

    # Add Stripe resources
    resource AshStripe.Customer
    resource AshStripe.Subscription
    resource AshStripe.PaymentMethod
    resource AshStripe.Invoice
    resource AshStripe.Product
    resource AshStripe.Price
  end
end
```

### 2. Use Stripe Resources Directly

```elixir
# Create a customer
{:ok, customer} = AshStripe.Customer
|> Ash.Changeset.for_create(:create, %{
  email: "customer@example.com",
  name: "John Doe"
})
|> Ash.create()

# List customers
customers = AshStripe.Customer
|> Ash.Query.limit(10)
|> Ash.read!()

# Get a specific customer
customer = AshStripe.Customer
|> Ash.Query.for_read(:get_by_id, %{id: "cus_123"})
|> Ash.read_one!()
```

### 3. Add Extension to Your Resources

```elixir
defmodule MyApp.User do
  use Ash.Resource,
    domain: MyApp.Domain,
    extensions: [AshStripe.Extension]

  ash_stripe do
    stripe_customer :stripe_customer_id
    stripe_subscription :subscription_id
  end

  attributes do
    uuid_primary_key :id
    attribute :email, :string
    attribute :stripe_customer_id, :string
    attribute :subscription_id, :string
  end

  # The extension automatically adds:
  # belongs_to :stripe_customer, AshStripe.Customer
  # belongs_to :stripe_subscription, AshStripe.Subscription
end
```

### 4. Load Stripe Data with Your Resources

```elixir
user = MyApp.User
|> Ash.Query.load([:stripe_customer, :stripe_subscription])
|> Ash.read_one!()

# Access Stripe data
customer_email = user.stripe_customer.email
subscription_status = user.stripe_subscription.status
```

## Advanced Usage

### Creating Customers with Organizations

```elixir
defmodule MyApp.Organization do
  use Ash.Resource,
    extensions: [AshStripe.Extension]

  ash_stripe do
    stripe_customer :stripe_customer_id
  end

  actions do
    create :create_with_stripe do
      accept [:name, :email]
      
      change fn changeset, _context ->
        email = Ash.Changeset.get_attribute(changeset, :email)
        
        case AshStripe.Helpers.create_stripe_customer_for(%{email: email}) do
          {:ok, customer} ->
            Ash.Changeset.change_attribute(changeset, :stripe_customer_id, customer.id)
          {:error, _} ->
            changeset
        end
      end
    end
  end
end
```

### Working with Subscriptions

```elixir
# Create a subscription
{:ok, subscription} = AshStripe.Subscription
|> Ash.Changeset.for_create(:create, %{
  customer: customer.id,
  items: %{
    "0" => %{price: "price_123"}
  }
})
|> Ash.create()

# Cancel a subscription
{:ok, cancelled} = AshStripe.Helpers.cancel_subscription(subscription)

# Get subscriptions for a customer
subscriptions = AshStripe.Subscription
|> Ash.Query.for_read(:for_customer, %{customer_id: customer.id})
|> Ash.read!()
```

### Product Catalog Management

```elixir
# Create a product
{:ok, product} = AshStripe.Product
|> Ash.Changeset.for_create(:create, %{
  name: "Pro Plan",
  description: "Professional features"
})
|> Ash.create()

# Create pricing
{:ok, price} = AshStripe.Price
|> Ash.Changeset.for_create(:create, %{
  product: product.id,
  currency: "usd",
  unit_amount: 2999, # $29.99
  recurring: %{interval: "month"}
})
|> Ash.create()
```

## Error Handling

AshStripe handles Stripe API errors and converts them to Ash errors:

```elixir
case AshStripe.Customer
     |> Ash.Changeset.for_create(:create, %{email: "invalid"})
     |> Ash.create() do
  {:ok, customer} -> 
    # Success
    customer
  {:error, %Ash.Error.Invalid{} = error} ->
    # Handle validation errors
    error
end
```

## Testing

For testing, you can mock Stripe API calls or use Stripe's test mode:

```elixir
# config/test.exs
config :ash_stripe,
  api_key: "sk_test_...",  # Use test API key
  api_version: "2025-02-24.acacia"
```

## Next Steps

- Review the [API documentation](https://hexdocs.pm/ash_stripe)
- Check out the [examples](examples/) directory
- Read about [Stripe's API](https://docs.stripe.com/api)
- Learn more about [Ash Framework](https://hexdocs.pm/ash)

## Common Patterns

### Webhook Handling

While AshStripe doesn't include webhook handling, you can easily add it:

```elixir
defmodule MyAppWeb.StripeWebhookController do
  use MyAppWeb, :controller

  def handle_webhook(conn, params) do
    case params["type"] do
      "customer.created" ->
        # Update your local data
        customer_data = params["data"]["object"]
        # Handle customer creation
        
      "invoice.payment_succeeded" ->
        # Handle successful payment
        
      _ ->
        # Handle other events
    end
    
    json(conn, %{received: true})
  end
end
```

This setup gives you a complete Stripe integration with minimal configuration!