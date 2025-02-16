defmodule Plants.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PlantsWeb.Telemetry,
      Plants.Repo,
      {DNSCluster, query: Application.get_env(:plants, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Plants.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Plants.Finch},
      # Start a worker by calling: Plants.Worker.start_link(arg)
      # {Plants.Worker, arg},
      # Start to serve requests, typically the last entry
      PlantsWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :plants]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Plants.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PlantsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
