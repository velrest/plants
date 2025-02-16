defmodule PlantCare.Plants do
  use Ash.Domain,
    otp_app: :plant_care

  resources do
    resource PlantCare.Plants.Plant do
      define :read_plants, action: :read
      define :create_plant, action: :create
      define :get_plant, action: :read, get_by: :id
      define :update_plant, action: :update
      define :destroy_plant, action: :destroy
    end

    resource PlantCare.Plants.Event do
      define :read_events, action: :read
      define :create_event, action: :create
      define :update_event, action: :update
      define :destroy_event, action: :destroy
    end
  end
end
