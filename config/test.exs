import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :checker_cab_demo, CheckerCabDemo.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "checker_cab_demo_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10,
  migration_timestamps: [type: :naive_datetime_usec]

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :checker_cab_demo, CheckerCabDemoWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "pdt1anpJOOLaLpmIPXr+9y3itIwyloLTyqqYdU0hc3rX70HY0swn49eKtoxnTZ9G",
  server: false

# In test we don't send emails.
config :checker_cab_demo, CheckerCabDemo.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
