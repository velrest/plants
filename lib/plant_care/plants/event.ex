defmodule PlantCare.Plants.Event do
  use Ash.Resource,
    otp_app: :plant_care,
    domain: PlantCare.Plants,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "events"
    repo PlantCare.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]
    default_accept [:type]
  end

  attributes do
    uuid_primary_key :id

    attribute :type, :atom do
      allow_nil? false
      constraints one_of: [:water, :checkup]
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end
end
