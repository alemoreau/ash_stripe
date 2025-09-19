defmodule AshStripe.Extension.Transformers.AddRelationships do
  @moduledoc """
  Transformer that adds Stripe relationships to resources based on the extension configuration.
  """
  
  use Spark.Dsl.Transformer
  
  def transform(dsl_state) do
    ash_stripe_config = Spark.Dsl.Extension.get_entities(dsl_state, [:ash_stripe])
    
    dsl_state =
      Enum.reduce(ash_stripe_config, dsl_state, fn entity, acc ->
        add_relationship_for_entity(acc, entity)
      end)
    
    {:ok, dsl_state}
  end
  
  def after_compile?, do: false
  
  defp add_relationship_for_entity(dsl_state, %AshStripe.Extension.StripeCustomer{} = entity) do
    relationship = %Ash.Resource.Relationships.BelongsTo{
      name: entity.relationship_name,
      destination: AshStripe.Customer,
      source_attribute: entity.attribute,
      destination_attribute: :id,
      allow_nil?: entity.allow_nil?,
      define_attribute?: false
    }
    
    Spark.Dsl.Transformer.add_entity(dsl_state, [:relationships], relationship)
  end
  
  defp add_relationship_for_entity(dsl_state, %AshStripe.Extension.StripeSubscription{} = entity) do
    relationship = %Ash.Resource.Relationships.BelongsTo{
      name: entity.relationship_name,
      destination: AshStripe.Subscription,
      source_attribute: entity.attribute,
      destination_attribute: :id,
      allow_nil?: entity.allow_nil?,
      define_attribute?: false
    }
    
    Spark.Dsl.Transformer.add_entity(dsl_state, [:relationships], relationship)
  end
  
  defp add_relationship_for_entity(dsl_state, %AshStripe.Extension.StripePaymentMethod{} = entity) do
    relationship = %Ash.Resource.Relationships.BelongsTo{
      name: entity.relationship_name,
      destination: AshStripe.PaymentMethod,
      source_attribute: entity.attribute,
      destination_attribute: :id,
      allow_nil?: entity.allow_nil?,
      define_attribute?: false
    }
    
    Spark.Dsl.Transformer.add_entity(dsl_state, [:relationships], relationship)
  end
end