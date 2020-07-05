defmodule API.ErrorView.NotFound do
  @moduledoc false

  alias Core.Errors.NotFound

  def error(%NotFound{} = error) do
    %{
      error: %{
        type: "not_found",
        message: Exception.message(error)
      }
    }
  end
end
