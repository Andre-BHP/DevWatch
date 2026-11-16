defmodule DevWatch.Repo do
  use Ecto.Repo,
    otp_app: :devwatch,
    adapter: Ecto.Adapters.Postgres
end
