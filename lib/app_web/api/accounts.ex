defmodule AppWeb.API.Accounts do
  alias App.Accounts
  alias AppWeb.Email
  alias App.Email.Mailer
  import AppWeb.API.Helpers

  def user_resolver(args, %{context: context}) do
    case args[:username] do
      nil ->
        case context[:user] do
          nil -> {:error, "Not authenticated and no username specified"}
          user -> {:ok, user}
        end
      username -> Accounts.user_by_username(username)
    end
  end

  def log_in_with_password(args, _info) do
    with {:ok, user} <- Accounts.authenticate(args),
      {:ok, macaroon} <- Accounts.create_session(user),
      {:ok, token} <- :macaroon.serialize(macaroon)
    do
      {:ok, %{user: user, token: token}}
    end
  end

  def sign_up_resolver(args, _info) do
    IO.puts("Here")
    v = Accounts.create_user(args)
    case v do
      {:ok, user} -> %{user: user, token: Accounts.create_session(user)}
      {:error, changeset} -> {:error, to_graphql_errors(changeset, "Error signing up")}
    end
  end

  def new_password_reset_token_resolver(%{email_or_username: email_or_username}, _info) do
    case Accounts.user_by_email_or_username(email_or_username) do
      nil -> {:error, "Email or username not found"}
      user ->
        case Accounts.create_password_reset_token(user) do
          {:ok, token} ->
            Email.password_reset(token)
            |> Mailer.deliver_later()
            {:ok, true}
          {:error, changeset} -> {:error, to_graphql_errors(changeset, "Error generating token")}
        end
    end
  end

  def is_valid_password_reset_token_resolver(%{token: token}, _info), do: {:ok, Accounts.valid_password_reset_token?(token)}

  def reset_password_resolver(%{token: token, new_password: new_password}, _info) do
    case Accounts.reset_password(token, new_password) do
      {:error, changeset} when is_map(changeset) -> {:error, to_graphql_errors(changeset, "Error updating password")}
      {:error, v} -> {:error, v}
      v -> v
    end
  end

end
