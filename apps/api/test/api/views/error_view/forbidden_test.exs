defmodule API.Views.ErrorView.ForbiddenTest do
  @moduledoc false

  use API.ConnCase, async: true

  import ExUnit.CaptureLog

  alias Core.Errors
  alias API.FallbackController

  test "renders forbidden error", %{conn: conn} do
    forbidden =
      Errors.forbidden(
        reason: :missing_permissions,
        details: [context: :accounts, resource: :user]
      )

    capture_log(fn ->
      conn = FallbackController.call(conn, forbidden)

      assert json_response(conn, 403)["error"] == %{
               "type" => "forbidden",
               "message" => "Forbidden: operation not allowed (missing_permissions)"
             }
    end)
  end
end
