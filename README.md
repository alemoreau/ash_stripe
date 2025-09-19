# AshStripe

An Ash extension for integrating Stripe with your Ash applications. This library provides:

- **Stripe API Client**: A `Req`-based HTTP client for the Stripe API
- **Ash Resources**: Pre-built Ash resources for Stripe entities (Customer, Subscription, PaymentMethod)
- **Ash Extension**: Easy integration of Stripe relationships into your existing Ash resources

## Installation

Add `ash_stripe` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ash_stripe, "~> 0.1.0"}
  ]
end
```

## Configuration

Configure your Stripe API key in your application:

```elixir
config :ash_stripe,
  api_key: System.get_env("STRIPE_SECRET_KEY"),
  api_version: "2025-02-24.acacia"
```

Or set the `STRIPE_SECRET_KEY` environment variable.

## Usage

### Using Stripe Resources Directly

You can use the pre-built Stripe resources in your domain:

```elixir
defmodule MyApp.Domain do
  use Ash.Domain
  
  resources do
    # Your existing resources
    resource MyApp.User
    resource MyApp.Organization
    
    # Stripe resources
    resource AshStripe.Customer
    resource AshStripe.Subscription
    resource AshStripe.PaymentMethod
  end
end
```

Then interact with Stripe data through Ash:

```elixir
# Create a customer
{:ok, customer} = AshStripe.Customer
|> Ash.Changeset.for_create(:create, %{
  email: "customer@example.com",
  name: "John Doe"
})
|> Ash.create!()

# List customers
customers = AshStripe.Customer
|> Ash.Query.limit(10)
|> Ash.read!()

# Get a customer by ID
customer = AshStripe.Customer
|> Ash.Query.for_read(:get_by_id, %{id: "cus_123"})
|> Ash.read_one!()
```

### Using the Extension

Add the extension to your existing resources to create relationships with Stripe:

```elixir
defmodule MyApp.Organization do
  use Ash.Resource,
    domain: MyApp.Domain,
    extensions: [AshStripe.Extension]
  
  ash_stripe do
    stripe_customer :stripe_customer_id
    stripe_subscription :stripe_subscription_id
    stripe_payment_method :default_payment_method_id
  end
  
  attributes do
    uuid_primary_key :id
    attribute :name, :string
    attribute :stripe_customer_id, :string
    attribute :stripe_subscription_id, :string
    attribute :default_payment_method_id, :string
  end
  
  # The extension automatically adds these relationships:
  # belongs_to :stripe_customer, AshStripe.Customer
  # belongs_to :stripe_subscription, AshStripe.Subscription
  # belongs_to :stripe_payment_method, AshStripe.PaymentMethod
end
```

Now you can load Stripe data alongside your existing data:

```elixir
organization = MyApp.Organization
|> Ash.Query.load([:stripe_customer, :stripe_subscription])
|> Ash.read_one!()

# Access Stripe customer data
customer_email = organization.stripe_customer.email
subscription_status = organization.stripe_subscription.status
```

## Available Resources

### AshStripe.Customer

Represents a Stripe customer with attributes like:
- `email`, `name`, `phone`
- `address`, `shipping`
- `metadata`, `balance`
- And more...

### AshStripe.Subscription

Represents a Stripe subscription with attributes like:
- `customer`, `status`, `current_period_start/end`
- `items`, `metadata`
- `trial_start`, `trial_end`
- And more...

### AshStripe.PaymentMethod

Represents a Stripe payment method with attributes like:
- `type`, `customer`
- `card`, `billing_details`
- `metadata`
- And more...

## Extension DSL

The extension provides these DSL options:

### `stripe_customer`

```elixir
stripe_customer :customer_id_attribute, relationship_name: :my_customer
```

### `stripe_subscription`

```elixir
stripe_subscription :subscription_id_attribute, relationship_name: :my_subscription
```

### `stripe_payment_method`

```elixir
stripe_payment_method :payment_method_id_attribute, relationship_name: :my_payment_method
```

## Direct API Access

You can also use the Stripe client directly:

```elixir
# Get a customer
{:ok, customer} = AshStripe.Client.get("/v1/customers/cus_123")

# Create a customer
{:ok, customer} = AshStripe.Client.post("/v1/customers", %{
  email: "test@example.com",
  name: "Test Customer"
})

# List customers with pagination
{:ok, %{"data" => customers}} = AshStripe.Client.get("/v1/customers", %{
  limit: 10,
  starting_after: "cus_123"
})
```

## Error Handling

The library handles Stripe API errors and converts them to appropriate Ash errors. Stripe validation errors, rate limits, and other API errors are properly propagated.

## Testing

The library includes test helpers and supports mocking Stripe API calls for testing. See the `test/` directory for examples.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License

MIT License. See [LICENSE](LICENSE) for details.