# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :test_case_phoenix,
  ecto_repos: [TestCasePhoenix.Repo]

# Configures the endpoint
config :test_case_phoenix, TestCasePhoenixWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "y9dAhPSSjQ0Cq20BNppDp+ZoF/VI/d9oBSxHe0zqWdI9H9R79gInt6szl/BqDIbZ",
  render_errors: [view: TestCasePhoenixWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TestCasePhoenix.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :test_case_phoenix, TestCasePhoenix.Guardian,
       issuer: "test_case_phoenix",
       secret_key: "zggZCd9G3i7irVCjAoPYsrlCF3EEWSqz9B6gJk1ml5Ma6RrwdWFKlAnvQdj43C+D"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
