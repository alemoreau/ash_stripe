defmodule AshStripe.Extension do
  @moduledoc """
  An Ash extension for integrating Stripe with your Ash applications.
  
  This extension allows you to easily set up relationships between your existing
  Ash resources and Stripe resources like customers, subscriptions, and payment methods.
  
  ## Usage
  
  Add this extension to your existing Ash resource:
  
      defmodule MyApp.Organization do
        use Ash.Resource,
          domain: MyApp.Domain,
          extensions: [AshStripe.Extension]
        
        ash_stripe do
          stripe_customer :customer_id
          stripe_subscription :subscription_id
        end
        
        attributes do
          uuid_primary_key :id
          attribute :name, :string
          attribute :customer_id, :string
          attribute :subscription_id, :string
        end
      end
  
  This will automatically add relationships to Stripe resources and provide
  helper functions for working with Stripe data.
  """
  
  @sections [:ash_stripe]
  
  use Spark.Dsl.Extension,
    sections: @sections,
    transformers: [AshStripe.Extension.Transformers.AddRelationships]
  
  def sections, do: @sections
  
  # DSL configuration
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
  
  @stripe_product_schema [
    attribute: [
      type: :atom,
      doc: "The attribute on this resource that contains the Stripe product ID",
      required: true
    ],
    relationship_name: [
      type: :atom,
      doc: "The name of the relationship to create",
      default: :stripe_product
    ],
    allow_nil?: [
      type: :boolean,
      doc: "Whether the relationship can be nil",
      default: true
    ]
  ]
  
  @stripe_price_schema [
    attribute: [
      type: :atom,
      doc: "The attribute on this resource that contains the Stripe price ID",
      required: true
    ],
    relationship_name: [
      type: :atom,
      doc: "The name of the relationship to create",
      default: :stripe_price
    ],
    allow_nil?: [
      type: :boolean,
      doc: "Whether the relationship can be nil",
      default: true
    ]
  ]
  
  @ash_stripe %Spark.Dsl.Section{
    name: :ash_stripe,
    describe: "Configuration for AshStripe extension",
    entities: [
      %Spark.Dsl.Entity{
        name: :stripe_customer,
        target: AshStripe.Extension.StripeCustomer,
        args: [:attribute],
        describe: "Defines a relationship to a Stripe customer",
        examples: [
          "stripe_customer :customer_id"
        ],
        schema: @stripe_customer_schema
      },
      %Spark.Dsl.Entity{
        name: :stripe_subscription,
        target: AshStripe.Extension.StripeSubscription,
        args: [:attribute],
        describe: "Defines a relationship to a Stripe subscription",
        examples: [
          "stripe_subscription :subscription_id"
        ],
        schema: @stripe_subscription_schema
      },
      %Spark.Dsl.Entity{
        name: :stripe_payment_method,
        target: AshStripe.Extension.StripePaymentMethod,
        args: [:attribute],
        describe: "Defines a relationship to a Stripe payment method",
        examples: [
          "stripe_payment_method :payment_method_id"
        ],
        schema: @stripe_payment_method_schema
      },
      %Spark.Dsl.Entity{
        name: :stripe_invoice,
        target: AshStripe.Extension.StripeInvoice,
        args: [:attribute],
        describe: "Defines a relationship to a Stripe invoice",
        examples: [
          "stripe_invoice :invoice_id"
        ],
        schema: @stripe_invoice_schema
      },
      %Spark.Dsl.Entity{
        name: :stripe_product,
        target: AshStripe.Extension.StripeProduct,
        args: [:attribute],
        describe: "Defines a relationship to a Stripe product",
        examples: [
          "stripe_product :product_id"
        ],
        schema: @stripe_product_schema
      },
      %Spark.Dsl.Entity{
        name: :stripe_price,
        target: AshStripe.Extension.StripePrice,
        args: [:attribute],
        describe: "Defines a relationship to a Stripe price",
        examples: [
          "stripe_price :price_id"
        ],
        schema: @stripe_price_schema
      }
    ]
  }
  
  use Spark.Dsl.Extension, sections: [@ash_stripe]
end