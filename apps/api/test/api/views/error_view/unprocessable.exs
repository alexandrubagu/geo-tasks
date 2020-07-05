defmodule API.Views.ErrorView.Unprocessable.ChangesetTest do
  @moduledoc false
  use API.ConnCase, async: true
  use Ecto.Schema

  import Ecto.Changeset
  alias API.FallbackController

  embedded_schema do
    field(:first_name, :string)
    field(:last_name, :string)
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:first_name, :last_name])
    |> validate_required([:first_name, :last_name])
    |> validate_length(:first_name, min: 2, max: 5)
    |> validate_inclusion(:last_name, ["joe", "jack"])
    |> add_error(:first_name, "its_not_ok")
  end

  test "renders nested ecto changeset errors", %{conn: conn} do
    changeset = changeset(%{first_name: "some fist name", last_name: "bad last name"})
    conn = FallbackController.call(conn, {:error, changeset})

    assert json_response(conn, 422)["error"] == %{
             "info" => %{
               "errors" => %{
                 "first_name" => ["its_not_ok", "should be at most 5 character(s)"],
                 "last_name" => ["is invalid"]
               }
             },
             "message" => "Validation failed",
             "type" => "unprocessable"
           }
  end
end
