defmodule AshStripe.Demo do
  @moduledoc """
  Demonstration of AshStripe functionality.
  
  This module shows how to use AshStripe in a real application.
  
  Note: These examples assume proper Stripe API key configuration
  and would make real API calls in a live environment.
  """
  
  @doc """
  Example: Create a customer and subscription flow
  """
  def create_customer_with_subscription_example do
    # 1. Create a Stripe customer
    {:ok, customer} = AshStripe.Customer
    |> Ash.Changeset.for_create(:create, %{
      email: "customer@example.com",
      name: "John Doe",
      phone: "+1234567890",
      metadata: %{
        "source" => "demo",
        "user_id" => "12345"
      }
    })
    |> Ash.create()
    
    # 2. Create a subscription for the customer
    {:ok, subscription} = AshStripe.Subscription
    |> Ash.Changeset.for_create(:create, %{
      customer: customer.id,
      items: %{
        "0" => %{
          price: "price_example123"
        }
      },
      metadata: %{
        "plan" => "pro"
      }
    })
    |> Ash.create()
    
    {:ok, %{customer: customer, subscription: subscription}}
  end
  
  @doc """
  Example: List all customers with pagination
  """
  def list_customers_example do
    AshStripe.Customer
    |> Ash.Query.limit(10)
    |> Ash.Query.sort([{:created, :desc}])
    |> Ash.read()
  end
  
  @doc """
  Example: Get customer with their subscriptions and payment methods
  """
  def get_customer_with_relationships_example(customer_id) do
    # Get subscriptions for customer
    {:ok, subscriptions} = AshStripe.Subscription
    |> Ash.Query.for_read(:for_customer, %{customer_id: customer_id})
    |> Ash.read()
    
    # Get payment methods for customer  
    {:ok, payment_methods} = AshStripe.PaymentMethod
    |> Ash.Query.for_read(:for_customer, %{customer_id: customer_id})
    |> Ash.read()
    
    # Get the customer
    {:ok, customer} = AshStripe.Customer
    |> Ash.Query.for_read(:get_by_id, %{id: customer_id})
    |> Ash.read_one()
    
    {:ok, %{
      customer: customer,
      subscriptions: subscriptions,
      payment_methods: payment_methods
    }}
  end
  
  @doc """
  Example: Using the extension in your own resource
  """
  def organization_with_stripe_example do
    quote do
      defmodule MyApp.Organization do
        use Ash.Resource,
          domain: MyApp.Domain,
          extensions: [AshStripe.Extension]
        
        ash_stripe do
          stripe_customer :stripe_customer_id
          stripe_subscription :primary_subscription_id
          stripe_payment_method :default_payment_method_id
        end
        
        attributes do
          uuid_primary_key :id
          attribute :name, :string, allow_nil?: false
          attribute :email, :string
          
          # Stripe relationship attributes
          attribute :stripe_customer_id, :string
          attribute :primary_subscription_id, :string
          attribute :default_payment_method_id, :string
          
          timestamps()
        end
        
        actions do
          defaults [:create, :read, :update, :destroy]
          
          create :create_with_stripe_customer do
            accept [:name, :email]
            
            change fn changeset, _context ->
              # Create Stripe customer when organization is created
              if email = Ash.Changeset.get_attribute(changeset, :email) do
                case AshStripe.Helpers.create_stripe_customer_for(%{email: email}) do
                  {:ok, customer} ->
                    Ash.Changeset.change_attribute(changeset, :stripe_customer_id, customer.id)
                  {:error, _} ->
                    changeset
                end
              else
                changeset
              end
            end
          end
        end
        
        # Extension automatically adds these relationships:
        # belongs_to :stripe_customer, AshStripe.Customer
        # belongs_to :stripe_subscription, AshStripe.Subscription
        # belongs_to :stripe_payment_method, AshStripe.PaymentMethod
      end
    end
  end
  
  @doc """
  Example: Working with products and prices
  """
  def product_catalog_example do
    # Create a product
    {:ok, product} = AshStripe.Product
    |> Ash.Changeset.for_create(:create, %{
      name: "Pro Plan",
      description: "Professional tier with advanced features",
      active: true,
      metadata: %{
        "tier" => "pro",
        "features" => "advanced"
      }
    })
    |> Ash.create()
    
    # Create prices for the product
    {:ok, monthly_price} = AshStripe.Price
    |> Ash.Changeset.for_create(:create, %{
      product: product.id,
      currency: "usd",
      unit_amount: 2999, # $29.99
      recurring: %{
        "interval" => "month"
      },
      lookup_key: "pro_monthly"
    })
    |> Ash.create()
    
    {:ok, yearly_price} = AshStripe.Price
    |> Ash.Changeset.for_create(:create, %{
      product: product.id,
      currency: "usd", 
      unit_amount: 29999, # $299.99
      recurring: %{
        "interval" => "year"
      },
      lookup_key: "pro_yearly"
    })
    |> Ash.create()
    
    {:ok, %{
      product: product,
      monthly_price: monthly_price,
      yearly_price: yearly_price
    }}
  end
  
  @doc """
  Example: Cancel a subscription
  """
  def cancel_subscription_example(subscription_id) do
    with {:ok, subscription} <- AshStripe.Subscription
                               |> Ash.Query.for_read(:get_by_id, %{id: subscription_id})
                               |> Ash.read_one(),
         {:ok, updated_subscription} <- AshStripe.Helpers.cancel_subscription(subscription) do
      {:ok, updated_subscription}
    end
  end
  
  @doc """
  Example: Using helpers for common operations
  """
  def helpers_example do
    # Create customer from any resource with email
    user = %{email: "user@example.com", name: "Jane Doe"}
    {:ok, customer} = AshStripe.Helpers.create_stripe_customer_for(user)
    
    # Create subscription for customer
    items = %{"0" => %{price: "price_123"}}
    {:ok, subscription} = AshStripe.Helpers.create_subscription_for_customer(customer.id, items)
    
    # Get payment methods for customer
    {:ok, payment_methods} = AshStripe.Helpers.get_payment_methods_for_customer(customer.id)
    
    {:ok, %{
      customer: customer,
      subscription: subscription,
      payment_methods: payment_methods
    }}
  end
end