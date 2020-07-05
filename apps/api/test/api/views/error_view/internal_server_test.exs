defmodule API.Views.ErrorView.InternalServerTest do
  @moduledoc false
  use API.ConnCase, async: true

  alias API.ErrorView

  test "renders internal server errors", %{conn: conn} do
    assert ErrorView.render("500.json", conn) == %{
             error: %{
               type: "internal_server",
               message: "500 Internal Server error"
             }
           }
  end
end
