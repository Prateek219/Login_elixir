defmodule Login.CRM do
    alias Login.Repo
    alias Login.CRM.Customer
  
    def build_customer(attrs \\ %{}) do
      %Customer{}
      |> Customer.changeset(attrs)
    end
  
    def create_customer(attrs) do
      attrs
      |> build_customer
      |> Repo.insert
    
    end
  
    
    def get_customer_by_email(email), do: Repo.get_by(Customer,email: email)
    def get_customer_by_credentials(%{"email" => email, "password_hash" =>
    password_hash}) do
      customer = get_customer_by_email(email)
      cond do
        customer && (password_hash == customer.password_hash) ->
          {:ok,customer}
        true ->
          {:error,:unauthorized}
      end
    end
  end