defmodule AshStripe.Extensions.Subscription do
  @moduledoc """
  An Ash extension for resources that need relationships to Stripe subscription data.
  
  This extension allows you to easily add relationships to Stripe subscription-related
  resources from your existing Ash resources.
  
  ## Usage
  
      defmodule MyApp.Membership do
        use Ash.Resource,
          domain: MyApp.Domain,
          extensions: [AshStripe.Extensions.Subscription]
        
        stripe_subscription do
          stripe_subscription :stripe_subscription_id
          stripe_customer :stripe_customer_id
        end
        
        attributes do
          uuid_primary_key :id
          attribute :stripe_subscription_id, :string
          attribute :stripe_customer_id, :string
        end
      end
  
  This will automatically add relationships to Stripe subscription-related resources.
  """
  
  @sections [:stripe_subscription]
  
  use Spark.Dsl.Extension,
    sections: @sections,
    transformers: [AshStripe.Extensions.Subscription.Transformers.AddRelationships]
  
  def sections, do: @sections
  
  # DSL configuration for subscription relationships
  @stripe_subscription_schema [
    attribute: [
      type: :atom,
      doc: "The attribute on this resource that contains the Stripe subscription ID",
      required: true
    ],
    relationship_name: [
      type: :atom,
      doc: "The name of the relationship to create",
      default: :stripe_subscription
    ],
    allow_nil?: [
      type: :boolean,
      doc: "Whether the relationship can be nil",
      default: true
    ]
  ]
  
  @stripe_customer_schema [
    attribute: [
      type: :atom,
      doc: "The attribute on this resource that contains the Stripe customer ID",
      required: true
    ],
    relationship_name: [
      type: :atom,
      doc: "The name of the relationship to create",
      default: :stripe_customer
    ],
    allow_nil?: [
      type: :boolean,
      doc: "Whether the relationship can be nil",
      default: true
    ]
  ]
  
  @stripe_subscription %Spark.Dsl.Section{
    name: :stripe_subscription,
    describe: "Configuration for Stripe subscription-related relationships",
    entities: [
      %Spark.Dsl.Entity{
        name: :stripe_subscription,
        target: AshStripe.Extensions.Subscription.StripeSubscription,
        args: [:attribute],
        describe: "Defines a relationship to a Stripe subscription",
        examples: [
          "stripe_subscription :subscription_id"
        ],
        schema: @stripe_subscription_schema
      },
      %Spark.Dsl.Entity{
        name: :stripe_customer,
        target: AshStripe.Extensions.Subscription.StripeCustomer,
        args: [:attribute],
        describe: "Defines a relationship to a Stripe customer",
        examples: [
          "stripe_customer :customer_id"
        ],
        schema: @stripe_customer_schema
      }
    ]
  }
  
  use Spark.Dsl.Extension, sections: [@stripe_subscription]
end