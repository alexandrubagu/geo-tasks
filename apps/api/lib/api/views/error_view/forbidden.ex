defmodule API.ErrorView.Forbidden do
  @moduledoc false

  def error(error) do
    %{
      error: %{
        type: "forbidden",
        message: Exception.message(error)
      }
    }
  end
end
