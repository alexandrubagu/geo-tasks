defmodule API.ErrorView.InternalServer do
  @moduledoc false

  def error(_) do
    %{
      error: %{
        type: "internal_server",
        message: "500 Internal Server error"
      }
    }
  end
end
