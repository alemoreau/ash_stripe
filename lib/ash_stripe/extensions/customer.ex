defmodule AshStripe.Extensions.Customer do
  @moduledoc """
  An Ash extension for resources that need relationships to Stripe customer data.
  
  This extension allows you to easily add relationships to Stripe customer-related
  resources from your existing Ash resources.
  
  ## Usage
  
      defmodule MyApp.Organization do
        use Ash.Resource,
          domain: MyApp.Domain,
          extensions: [AshStripe.Extensions.Customer]
        
        stripe_customer do
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
      end
  
  This will automatically add relationships to Stripe customer-related resources.
  """
  
  @sections [:stripe_customer]
  
  use Spark.Dsl.Extension,
    sections: @sections,
    transformers: [AshStripe.Extensions.Customer.Transformers.AddRelationships]
  
  def sections, do: @sections
  
  # DSL configuration for customer relationships
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
  
  @stripe_payment_method_schema [
    attribute: [
      type: :atom,
      doc: "The attribute on this resource that contains the Stripe payment method ID",
      required: true
    ],
    relationship_name: [
      type: :atom,
      doc: "The name of the relationship to create",
      default: :stripe_payment_method
    ],
    allow_nil?: [
      type: :boolean,
      doc: "Whether the relationship can be nil",
      default: true
    ]
  ]
  
  @stripe_invoice_schema [
    attribute: [
      type: :atom,
      doc: "The attribute on this resource that contains the Stripe invoice ID",
      required: true
    ],
    relationship_name: [
      type: :atom,
      doc: "The name of the relationship to create",
      default: :stripe_invoice
    ],
    allow_nil?: [
      type: :boolean,
      doc: "Whether the relationship can be nil",
      default: true
    ]
  ]
  
  @stripe_customer %Spark.Dsl.Section{
    name: :stripe_customer,
    describe: "Configuration for Stripe customer-related relationships",
    entities: [
      %Spark.Dsl.Entity{
        name: :stripe_customer,
        target: AshStripe.Extensions.Customer.StripeCustomer,
        args: [:attribute],
        describe: "Defines a relationship to a Stripe customer",
        examples: [
          "stripe_customer :customer_id"
        ],
        schema: @stripe_customer_schema
      },
      %Spark.Dsl.Entity{
        name: :stripe_subscription,
        target: AshStripe.Extensions.Customer.StripeSubscription,
        args: [:attribute],
        describe: "Defines a relationship to a Stripe subscription",
        examples: [
          "stripe_subscription :subscription_id"
        ],
        schema: @stripe_subscription_schema
      },
      %Spark.Dsl.Entity{
        name: :stripe_payment_method,
        target: AshStripe.Extensions.Customer.StripePaymentMethod,
        args: [:attribute],
        describe: "Defines a relationship to a Stripe payment method",
        examples: [
          "stripe_payment_method :payment_method_id"
        ],
        schema: @stripe_payment_method_schema
      },
      %Spark.Dsl.Entity{
        name: :stripe_invoice,
        target: AshStripe.Extensions.Customer.StripeInvoice,
        args: [:attribute],
        describe: "Defines a relationship to a Stripe invoice",
        examples: [
          "stripe_invoice :invoice_id"
        ],
        schema: @stripe_invoice_schema
      }
    ]
  }
  
  use Spark.Dsl.Extension, sections: [@stripe_customer]
end