defmodule Doit.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    children =
      [
        # Start the Ecto repository
        Doit.Repo,
        # Start the Telemetry supervisor
        DoitWeb.Telemetry,
        # Start the PubSub system
        {Phoenix.PubSub, name: Doit.PubSub},
        # Start the Endpoint (http/https)
        DoitWeb.Endpoint
        # Start a worker by calling: Doit.Worker.start_link(arg)
        # {Doit.Worker, arg}
      ] ++ manual_start_in_test()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Doit.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @spec config_change(any, any, any) :: :ok
  def config_change(changed, _new, removed) do
    DoitWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  @spec manual_start_in_test :: [{Doit.PeriodicJob, []}]
  def manual_start_in_test do
    if test?() do
      []
    else
      [{Doit.PeriodicJob, []}, {Doit.NotificationPipeline, []}]
    end
  end

  defp test? do
    Application.get_env(:doit, :env) == :test
  end
end
