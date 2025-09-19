defmodule AshStripe.Extensions.Product.Transformers.AddRelationships do
  @moduledoc """
  Transformer that adds Stripe product-related relationships to resources.
  """
  
  use Spark.Dsl.Transformer
  
  def transform(dsl_state) do
    stripe_product_config = Spark.Dsl.Extension.get_entities(dsl_state, [:stripe_product])
    
    dsl_state =
      Enum.reduce(stripe_product_config, dsl_state, fn entity, acc ->
        add_relationship_for_entity(acc, entity)
      end)
    
    {:ok, dsl_state}
  end
  
  def after_compile?, do: false
  
  defp add_relationship_for_entity(dsl_state, %AshStripe.Extensions.Product.StripeProduct{} = entity) do
    relationship = %Ash.Resource.Relationships.BelongsTo{
      name: entity.relationship_name,
      destination: AshStripe.Product,
      source_attribute: entity.attribute,
      destination_attribute: :id,
      allow_nil?: entity.allow_nil?,
      define_attribute?: false
    }
    
    Spark.Dsl.Transformer.add_entity(dsl_state, [:relationships], relationship)
  end
  
  defp add_relationship_for_entity(dsl_state, %AshStripe.Extensions.Product.StripePrice{} = entity) do
    relationship = %Ash.Resource.Relationships.BelongsTo{
      name: entity.relationship_name,
      destination: AshStripe.Price,
      source_attribute: entity.attribute,
      destination_attribute: :id,
      allow_nil?: entity.allow_nil?,
      define_attribute?: false
    }
    
    Spark.Dsl.Transformer.add_entity(dsl_state, [:relationships], relationship)
  end
end