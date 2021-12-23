defmodule Login.Repo do
  use Ecto.Repo,
    otp_app: :login,
    adapter: Ecto.Adapters.Postgres
end
