defmodule API.Views.ErrorView.UnauthorizedTest do
  @moduledoc false
  use API.ConnCase, async: true

  alias Core.Errors
  alias API.FallbackController

  test "renders not unauthorized error", %{conn: conn} do
    conn = FallbackController.call(conn, Errors.unauthorized(_opts = []))

    assert %{
             "message" =>
               "Unauthorized: Request is not allowed because of authentication problems.",
             "type" => "unauthorized"
           } == json_response(conn, 401)["error"]
  end
end
