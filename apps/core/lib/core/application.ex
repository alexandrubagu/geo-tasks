defmodule Core.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Core.Repo
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Core.Supervisor)
  end
end
