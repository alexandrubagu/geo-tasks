defmodule API.ErrorView.Unprocessable do
  @moduledoc false

  require Logger

  def error(changeset) do
    errors =
      Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)

    %{
      error: %{
        type: :unprocessable,
        message: "Validation failed",
        info: %{errors: errors}
      }
    }
  end
end
