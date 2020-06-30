defmodule Core.Tasks.Location do
  use Core.Schema

  @required ~w(lat long)a
  @primary_key false
  embedded_schema do
    field :lat, :string
    field :long, :string
  end

  def changeset(location, attrs) do
    location
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end
