# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ex_blog,
  ecto_repos: [ExBlog.Repo]

# Configures the endpoint
config :ex_blog, ExBlogWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "RVBI7AxTYEL3olXs9dX0G9p5e9UFBZ0i7Qzt7FXnM4X1l4DqMl+Txk8trNmUUc71",
  render_errors: [view: ExBlogWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ExBlog.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
