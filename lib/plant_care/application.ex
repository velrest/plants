defmodule PlantCare.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PlantCareWeb.Telemetry,
      PlantCare.Repo,
      {DNSCluster, query: Application.get_env(:plant_care, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PlantCare.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PlantCare.Finch},
      # Start a worker by calling: PlantCare.Worker.start_link(arg)
      # {PlantCare.Worker, arg},
      # Start to serve requests, typically the last entry
      PlantCareWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :plant_care]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PlantCare.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PlantCareWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
