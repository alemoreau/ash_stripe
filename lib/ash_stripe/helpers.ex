defmodule AshStripe.Helpers do
  @moduledoc """
  Utility functions for working with AshStripe resources.
  """
  
  @doc """
  Creates a Stripe customer from an Ash resource with email.
  """
  def create_stripe_customer_for(resource) when is_struct(resource) do
    email = get_email_from_resource(resource)
    name = get_name_from_resource(resource)
    
    attrs = %{email: email}
    attrs = if name, do: Map.put(attrs, :name, name), else: attrs
    
    AshStripe.Customer
    |> Ash.Changeset.for_create(:create, attrs)
    |> Ash.create()
  end
  
  @doc """
  Creates a subscription for a customer.
  """
  def create_subscription_for_customer(customer_id, items) when is_binary(customer_id) do
    AshStripe.Subscription
    |> Ash.Changeset.for_create(:create, %{
      customer: customer_id,
      items: items
    })
    |> Ash.create()
  end
  
  @doc """
  Cancels a subscription at period end.
  """
  def cancel_subscription(subscription) when is_struct(subscription) do
    subscription
    |> Ash.Changeset.for_update(:cancel)
    |> Ash.update()
  end
  
  @doc """
  Gets payment methods for a customer.
  """
  def get_payment_methods_for_customer(customer_id) when is_binary(customer_id) do
    AshStripe.PaymentMethod
    |> Ash.Query.for_read(:for_customer, %{customer_id: customer_id})
    |> Ash.read()
  end
  
  @doc """
  Attaches a payment method to a customer.
  """
  def attach_payment_method_to_customer(payment_method, customer_id) when is_struct(payment_method) and is_binary(customer_id) do
    payment_method
    |> Ash.Changeset.for_update(:attach, %{customer_id: customer_id})
    |> Ash.update()
  end
  
  # Private helper functions
  
  defp get_email_from_resource(resource) do
    cond do
      Map.has_key?(resource, :email) and resource.email -> resource.email
      Map.has_key?(resource, :email_address) and resource.email_address -> resource.email_address
      true -> nil
    end
  end
  
  defp get_name_from_resource(resource) do
    cond do
      Map.has_key?(resource, :name) and resource.name -> resource.name
      Map.has_key?(resource, :full_name) and resource.full_name -> resource.full_name
      Map.has_key?(resource, :first_name) and Map.has_key?(resource, :last_name) ->
        "#{resource.first_name} #{resource.last_name}"
      true -> nil
    end
  end
end