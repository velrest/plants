defmodule PlantCare.Repo.Migrations.AddRelationships do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:events) do
      add :plant_id,
          references(:plants,
            column: :id,
            name: "events_plant_id_fkey",
            type: :uuid,
            prefix: "public"
          )
    end
  end

  def down do
    drop constraint(:events, "events_plant_id_fkey")

    alter table(:events) do
      remove :plant_id
    end
  end
end
