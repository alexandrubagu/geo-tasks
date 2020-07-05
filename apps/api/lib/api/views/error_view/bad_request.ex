defmodule API.ErrorView.BadRequest do
  @moduledoc false

  def error(_) do
    %{
      error: %{
        type: "bad_request",
        message: "400 Bad Request"
      }
    }
  end
end
