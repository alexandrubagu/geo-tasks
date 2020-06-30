defmodule Core.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :type, :integer
      add :pickup, :map, null: false
      add :delivery, :map, null: false

      timestamps()
    end

    create index(:tasks, :type)
  end
end
