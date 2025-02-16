defmodule Plants.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], Plants.Accounts.User, _opts) do
    Application.fetch_env(:plants, :token_signing_secret)
  end
end
