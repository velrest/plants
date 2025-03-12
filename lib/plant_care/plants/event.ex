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
    default_accept [:type, :date]
  end

  attributes do
    uuid_primary_key :id

    attribute :type, :atom do
      allow_nil? false
      constraints one_of: [:water, :checkup]
    end

    attribute :date, :datetime do
      default &DateTime.utc_now/0
      allow_nil? false
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :plant, PlantCare.Plants.Plant
  end
end
