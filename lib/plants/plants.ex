defmodule Plants.Plants do
  use Ash.Domain,
    otp_app: :plants

  resources do
    resource Plants.Plants.Plant do
      define :read_plants, action: :read
      define :create_plant, action: :create
      define :get_plant, action: :read, get_by: :id
      define :update, action: :update
      define :destroy, action: :destroy
    end

    resource Plants.Plants.Event do
      define :read_events, action: :read
      define :create_event, action: :create
      define :update, action: :update
      define :destroy, action: :destroy
    end
  end
end
