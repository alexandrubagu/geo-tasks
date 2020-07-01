defmodule Core.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :state, :integer
      add :pickup, :map, null: false
      add :delivery, :map, null: false
      add :user_id, references(:users, on_delete: :restrict, type: :binary_id)

      timestamps()
    end

    create index(:tasks, :state)
  end
end
