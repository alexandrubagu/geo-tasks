defmodule API.ErrorView do
  use API, :view

  alias __MODULE__

  def render("401.json", error), do: ErrorView.Unauthorized.error(error)
  def render("403.json", error), do: ErrorView.Forbidden.error(error)
  def render("404.json", error), do: ErrorView.NotFound.error(error)
  def render("422.json", error), do: ErrorView.Unprocessable.error(error)
  def render("500.json", error), do: ErrorView.InternalServer.error(error)

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
