defmodule DevWatch.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DevWatch.Repo,
      {Phoenix.PubSub, name: DevWatch.PubSub},
      DevWatchWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: DevWatch.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    DevWatchWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
