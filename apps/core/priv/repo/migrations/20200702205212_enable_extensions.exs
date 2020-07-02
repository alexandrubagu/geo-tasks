defmodule Core.Repo.Migrations.EnableExtensions do
  use Ecto.Migration

  def up do
    Core.Repo.query("CREATE EXTENSION cube;")
    Core.Repo.query("CREATE EXTENSION earthdistance;")
  end
end
