defmodule Plants.Plants.Plant do
  use Ash.Resource,
    otp_app: :plants,
    domain: Plants.Plants,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "plants"
    repo Plants.Repo
  end

  actions do
    defaults [:create, :read, :update, :destory]
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
end
