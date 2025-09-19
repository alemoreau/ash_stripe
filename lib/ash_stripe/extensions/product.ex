defmodule AshStripe.Extensions.Product do
  @moduledoc """
  An Ash extension for resources that need relationships to Stripe product data.
  
  This extension allows you to easily add relationships to Stripe product-related
  resources from your existing Ash resources.
  
  ## Usage
  
      defmodule MyApp.Product do
        use Ash.Resource,
          domain: MyApp.Domain,
          extensions: [AshStripe.Extensions.Product]
        
        stripe_product do
          stripe_product :stripe_product_id
          stripe_price :default_price_id
        end
        
        attributes do
          uuid_primary_key :id
          attribute :name, :string
          attribute :stripe_product_id, :string
          attribute :default_price_id, :string
        end
      end
  
  This will automatically add relationships to Stripe product-related resources.
  """
  
  @sections [:stripe_product]
  
  use Spark.Dsl.Extension,
    sections: @sections,
    transformers: [AshStripe.Extensions.Product.Transformers.AddRelationships]
  
  def sections, do: @sections
  
  # DSL configuration for product relationships
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
  
  @stripe_product %Spark.Dsl.Section{
    name: :stripe_product,
    describe: "Configuration for Stripe product-related relationships",
    entities: [
      %Spark.Dsl.Entity{
        name: :stripe_product,
        target: AshStripe.Extensions.Product.StripeProduct,
        args: [:attribute],
        describe: "Defines a relationship to a Stripe product",
        examples: [
          "stripe_product :product_id"
        ],
        schema: @stripe_product_schema
      },
      %Spark.Dsl.Entity{
        name: :stripe_price,
        target: AshStripe.Extensions.Product.StripePrice,
        args: [:attribute],
        describe: "Defines a relationship to a Stripe price",
        examples: [
          "stripe_price :price_id"
        ],
        schema: @stripe_price_schema
      }
    ]
  }
  
  use Spark.Dsl.Extension, sections: [@stripe_product]
end