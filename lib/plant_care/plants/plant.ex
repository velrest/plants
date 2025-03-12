defmodule PlantCare.Plants.Plant do
  use Ash.Resource,
    otp_app: :plant_care,
    domain: PlantCare.Plants,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "plants"
    repo PlantCare.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]
    default_accept [:name]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    has_many :events, PlantCare.Plants.Event
  end
end
