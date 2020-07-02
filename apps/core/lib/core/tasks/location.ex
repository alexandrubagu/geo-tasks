defmodule Core.Tasks.Location do
  use Core.Schema

  @required ~w(lat long)a
  @primary_key false
  embedded_schema do
    field :lat, :float
    field :long, :float
  end

  def changeset(location, attrs) do
    location
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> validate_number(:lat, greater_than_or_equal_to: -90, less_than_or_equal_to: 90)
    |> validate_number(:long, greater_than_or_equal_to: -180, less_than_or_equal_to: 180)
  end
end
