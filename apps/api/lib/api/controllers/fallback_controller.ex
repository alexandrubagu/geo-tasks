defmodule API.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.
  """

  @behaviour Plug

  import Plug.Conn
  import API.ErrorView

  alias Core.Errors

  require Logger

  def init(opts), do: opts

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    send_response(conn, 422, render("422.json", changeset))
  end

  def call(conn, {:error, %Errors.NotFound{} = error}) do
    send_response(conn, 404, render("404.json", error))
  end

  def call(conn, {:error, %Errors.Forbidden{} = error}) do
    Logger.warn("forbidden operation: #{inspect(error)}")
    send_response(conn, 403, render("403.json", error))
  end

  def call(conn, {:error, %Errors.Unauthorized{} = error}) do
    send_response(conn, 401, render("401.json", error))
  end

  defp send_response(conn, http_status, response_body) do
    conn
    |> put_resp_content_type("application/json")
    |> resp(http_status, Jason.encode!(response_body))
  end
end
