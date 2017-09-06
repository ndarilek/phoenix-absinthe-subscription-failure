defmodule AppWeb.API do
  use Absinthe.Ecto, repo: App.Repo
  use Absinthe.Schema
  alias AppWeb.API.Accounts

  @desc "Represents a user."
  object :user do

    @desc """
    The email address for this user.

    Authenticated users can view their own email address.

    Requesting an email address for anyone other than the currently authenticated user returns an error.
    """
    field :email, non_null(:string) do
      resolve fn(_args, %{context: context, source: source}) ->
        if source.id == context[:user].id do
          {:ok, source.email}
        else
          {:error, "Cannot retrieve this user's email"}
        end
      end
    end

    field :username, non_null(:string)
  end

  @doc """
  Contains a token and `User` object, returned on login or signup.
  """
  object :sign_in_payload do
    field :token, non_null(:string)
    field :user, non_null(:user)
  end

  query do

    @desc """
    Checks whether the submitted password reset token is valid.
    """
    field :is_valid_password_reset_token, non_null(:boolean) do
      arg :token, non_null(:string)
      resolve(&Accounts.is_valid_password_reset_token_resolver/2)
    end

    @desc """
    Retrieves the `User` with the specified `username`.
    """
    field :user, :user do
      arg :username, :string
      resolve(&Accounts.user_resolver/2)
    end

  end

  mutation do

    @desc """
    Attempts to log in with the specified `username` and `password`.

    Returns a `SignInPayload` containing a macaroon in the `token` field, which must be included in the header of requests to this API in the following format:

    `authorization: Bearer <macaroon>`
    """
    field :log_in_with_password, :sign_in_payload do
      arg :email_or_username, non_null(:string)
      arg :password, non_null(:string)
      resolve(&Accounts.log_in_with_password/2)
    end

    @desc """
    Initiates the password-reset flow.

    Successful password reset involves the following steps:
    1. Send `mutation(...) { newPasswordResetToken(...) }`
    2. The user receives an email linking them to their password-reset page.
    3. On that page, send `query(...) { isValidPasswordResetToken(...) }` to determine if the token is valid before sending a password over the wire.
    4. If the token is valid, send `mutation(...) { resetPassword(...) }` to reset the password and complete the flow.
    """
    field :new_password_reset_token, :boolean do
      arg :email_or_username, non_null(:string)
      resolve(&Accounts.new_password_reset_token_resolver/2)
    end

    @desc """
    Given a password-reset token and a new password, reset the user's password.
    """
    field :reset_password, :string do
      arg :token, non_null(:string)
      arg :new_password, non_null(:string)
      resolve(&Accounts.reset_password_resolver/2)
    end

    @desc """
    Signs up for an account with an email address, username, and password.

    Returns a `SignInPayload` containing a macaroon in the `token` field, which must be included in the header of requests to this API in the following format:

    `Authorization: Bearer <macaroon>`
    """
    field :sign_up, non_null(:sign_in_payload) do
      arg :username, non_null(:string)
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve(&Accounts.sign_up_resolver/2)
    end

  end

end
