defmodule Plants.Accounts do
  use Ash.Domain, otp_app: :plants, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource Plants.Accounts.Token
    resource Plants.Accounts.User
  end
end
