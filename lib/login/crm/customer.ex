defmodule Login.CRM.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "customers" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :phone, :string
    field :residence_area, :string
    field :password_hash_reset_token, :string
    field :password_hash_reset_sent_at, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:name, :email, :phone, :residence_area, :password_hash])
    |> validate_required([:name, :email, :phone, :residence_area, :password_hash])
    |> cast(attrs, [:email, :password_hash, :password_hash_reset_token, :password_hash_reset_sent_at])
    |> unique_constraint(:email)
    |> validate_confirmation(:encrypted_password)
  end
  def get_customer_from_token(token) do
    Repo.get_by(Customer, password_hash_reset_token: token)
  end
  
  def set_token_on_customer(customer) do
    attrs = %{
      "password_hash_reset_token" => SecureRandom.urlsafe_base64(),
      "password_hash_reset_sent_at" => NaiveDateTime.utc_now()
    }
  
    customer
    |> Customer.changeset(attrs)
    |> Repo.update!()
  end
  def valid_token?(token_sent_at) do
    current_time = NaiveDateTime.utc_now()
    Time.diff(current_time, token_sent_at) < 7200
  end
  
end
