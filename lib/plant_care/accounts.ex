defmodule PlantCare.Accounts do
  use Ash.Domain, otp_app: :plant_care, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource PlantCare.Accounts.Token
    resource PlantCare.Accounts.User
  end
end
