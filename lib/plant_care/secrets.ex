defmodule PlantCare.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], PlantCare.Accounts.User, _opts) do
    Application.fetch_env(:plant_care, :token_signing_secret)
  end
end
