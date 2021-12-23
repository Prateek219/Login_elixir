defmodule Login.Repo.Migrations.AddPassResetTokenToCustomers do
  use Ecto.Migration

  def change do
    alter table("customers") do
      add :password_reset_token, :string
      add :password_reset_sent_at, :naive_datetime
    end
  end

  
end
