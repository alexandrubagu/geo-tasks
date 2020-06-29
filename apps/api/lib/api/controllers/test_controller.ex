defmodule API.TestController do
  use API, :controller

  def index(conn, _params), do: json(conn, %{data: "ok"})
end
