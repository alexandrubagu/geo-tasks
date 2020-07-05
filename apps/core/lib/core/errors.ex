defmodule Core.Errors do
  @moduledoc """
  Core Errors
  """

  defmodule NotFound do
    @moduledoc """
    Represent the error of not finding a resource
    """
    defexception [:resource, :identifier]

    @impl true
    def exception(opts) do
      %__MODULE__{
        resource: Keyword.fetch!(opts, :resource),
        identifier: Keyword.fetch!(opts, :identifier)
      }
    end

    @impl true
    def message(e), do: "Could not find #{e.resource} with identifier: #{e.identifier}"
  end

  defmodule Forbidden do
    @moduledoc """
    Represent the forbidden error.

    Example:
        iex> raise Forbidden, reason: :insufficient_permissions
        ** (Core.Errors.Forbidden) Forbidden: operation not allowed (insufficient_permissions)

    """

    defexception [:reason]

    @impl true
    def exception(opts), do: %__MODULE__{reason: Keyword.fetch!(opts, :reason)}

    @impl true
    def message(e), do: "Forbidden: operation not allowed (#{e.reason})"
  end

  defmodule Unauthorized do
    @moduledoc """
    Represent the unauthorized error
    """

    defexception []

    @impl true
    def exception(_), do: %__MODULE__{}

    @impl true
    def message(_), do: "Unauthorized: Request is not allowed because of authentication problems."
  end

  def not_found(opts), do: {:error, NotFound.exception(opts)}
  def not_found_if_nil(nil, opts), do: {:error, NotFound.exception(opts)}
  def not_found_if_nil(found, _), do: {:ok, found}

  def forbidden(opts), do: {:error, Forbidden.exception(opts)}

  def unauthorized(opts \\ []), do: {:error, Unauthorized.exception(opts)}
end
