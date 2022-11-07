defmodule CheckerCabDemo.Repo do
  use Ecto.Repo,
    otp_app: :checker_cab_demo,
    adapter: Ecto.Adapters.Postgres
end
