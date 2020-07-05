defmodule API.Views.ErrorView.NotFoundTest do
  @moduledoc false
  use API.ConnCase, async: true

  alias Core.Errors
  alias API.FallbackController

  test "renders not found error", %{conn: conn} do
    conn = FallbackController.call(conn, Errors.not_found(resource: :user, identifier: 1))

    assert %{
             "message" => "Could not find user with identifier: 1",
             "type" => "not_found"
           } == json_response(conn, 404)["error"]
  end
end
