defmodule PlantCare.Repo.Migrations.AddDefaultEventDate do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:events) do
      modify :date, :utc_datetime, default: fragment("(now() AT TIME ZONE 'utc')")
    end
  end

  def down do
    alter table(:events) do
      modify :date, :utc_datetime, default: nil
    end
  end
end
