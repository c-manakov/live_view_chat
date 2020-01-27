defmodule TestCasePhoenix.Repo do
  use Ecto.Repo,
    otp_app: :test_case_phoenix,
    adapter: Ecto.Adapters.Postgres
end
