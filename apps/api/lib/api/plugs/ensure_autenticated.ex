defmodule API.Plugs.EnsureAuthenticated do
  @moduledoc false

  @behaviour Plug

  import Plug.Conn
  require Logger

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    case authenticate(conn) do
      {:ok, user} -> assign(conn, :logged_user, user)
      {:error, _} = error -> API.FallbackController.call(conn, error)
    end
  end

  defp authenticate(conn) do
    case get_req_header(conn, "authorization") do
      [] -> Core.Errors.unauthorized()
      [header | _] -> header |> String.replace("Bearer ", "") |> Core.authenticate()
    end
  end
end
