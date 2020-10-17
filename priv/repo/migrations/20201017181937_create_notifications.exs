defmodule Doit.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :type, :string
      add :data, :map

      timestamps()
    end
  end
end
