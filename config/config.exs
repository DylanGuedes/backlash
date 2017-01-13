# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :backlash,
  ecto_repos: [Backlash.Repo]

# Configures the endpoint
config :backlash, Backlash.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "C+qz8m731aAxRQnE9QGQbzhx8KZ8lCc9POv6Yao2UO5VoOs5WJe5mlTtyuSqTjS8",
  render_errors: [view: Backlash.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Backlash.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
