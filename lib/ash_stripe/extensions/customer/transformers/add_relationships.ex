defmodule AshStripe.Extensions.Customer.Transformers.AddRelationships do
  @moduledoc """
  Transformer that adds Stripe customer-related relationships to resources.
  """
  
  use Spark.Dsl.Transformer
  
  def transform(dsl_state) do
    stripe_customer_config = Spark.Dsl.Extension.get_entities(dsl_state, [:stripe_customer])
    
    dsl_state =
      Enum.reduce(stripe_customer_config, dsl_state, fn entity, acc ->
        add_relationship_for_entity(acc, entity)
      end)
    
    {:ok, dsl_state}
  end
  
  def after_compile?, do: false
  
  defp add_relationship_for_entity(dsl_state, %AshStripe.Extensions.Customer.StripeCustomer{} = entity) do
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
  
  defp add_relationship_for_entity(dsl_state, %AshStripe.Extensions.Customer.StripeSubscription{} = entity) do
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
  
  defp add_relationship_for_entity(dsl_state, %AshStripe.Extensions.Customer.StripePaymentMethod{} = entity) do
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
  
  defp add_relationship_for_entity(dsl_state, %AshStripe.Extensions.Customer.StripeInvoice{} = entity) do
    relationship = %Ash.Resource.Relationships.BelongsTo{
      name: entity.relationship_name,
      destination: AshStripe.Invoice,
      source_attribute: entity.attribute,
      destination_attribute: :id,
      allow_nil?: entity.allow_nil?,
      define_attribute?: false
    }
    
    Spark.Dsl.Transformer.add_entity(dsl_state, [:relationships], relationship)
  end
end