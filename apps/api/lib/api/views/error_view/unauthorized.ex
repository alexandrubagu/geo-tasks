defmodule API.ErrorView.Unauthorized do
  @moduledoc false

  def error(error) do
    %{
      error: %{
        type: "unauthorized",
        message: Exception.message(error)
      }
    }
  end
end
