defmodule App.Accounts do
  @moduledoc """
  The boundary for the Accounts system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias App.Repo
  alias AppWeb.Endpoint
  alias Phoenix.Token

  alias App.Accounts.PasswordResetToken
  alias App.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> user_changeset(attrs)
    |> Repo.update()
  end

  def user_by_id(id), do: Repo.get(User, id)

  def user_by_username(username), do: Repo.get_by(User, username: username)

  def user_by_email_or_username(email_or_username) do
    email_or_username = String.downcase(email_or_username) |> String.trim()
    Repo.one(from user in User, where: user.email == ^email_or_username or user.username == ^email_or_username)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> user_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def authenticate(%{email_or_username: emailOrUsername, password: password}) do
    emailOrUsername = String.downcase(emailOrUsername) |> String.trim()
    user = Repo.one(from user in User, where: user.email == ^emailOrUsername or user.username == ^emailOrUsername)
    case user do
      nil -> {:error, "Account not found"}
      user ->
        case check_password(user, password) do
          true -> {:ok, user}
          false -> {:error, "Invalid credentials"}
        end
    end
  end

  def create_session(user) do
    secret = Application.get_env(:app, AppWeb.Endpoint)[:secret_key_base]
    public = user.id
    location = Application.get_env(:app, AppWeb.Endpoint)[:url]
    macaroon = :macaroon.create(location, secret, public)
    {:ok, macaroon}
  end

  defp check_password(user, password) do
    case user do
      nil -> Comeonin.Bcrypt.dummy_checkpw()
      _ -> Comeonin.Bcrypt.checkpw(password, user.password)
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    user_changeset(user, %{})
  end

  def user_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password])
    |> validate_required([:email, :username, :password])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:username)
    |> validate_format(:username, ~r/^\w+$/)
    |> validate_length(:username, min: 3)
    |> validate_length(:password, min: 8)
    |> change(email: String.downcase(attrs[:email] || ""))
    |> change(email: String.trim(attrs[:email] || ""))
    |> change(username: String.downcase(attrs[:username] || ""))
    |> change(username: String.trim(attrs[:username] || ""))
  end

  def create_password_reset_token(%User{} = user) do
    %PasswordResetToken{}
    |> password_reset_token_changeset(user)
    |> Repo.insert()
  end

  def valid_password_reset_token?(token) do
    case Repo.one(from t in PasswordResetToken, where: t.value == ^token) do
      nil -> false
      _v -> true
    end
  end

  def reset_password(token, new_password) do
    case Repo.one(from t in PasswordResetToken, where: t.value == ^token) do
      nil -> {:error, "Token not found"}
      t ->
        t = Repo.preload(t, :user)
        case t.user do
          nil ->
            Repo.delete!(t)
            {:error, "User not found"}
          user ->
            case  update_user(user, %{password: new_password}) do
              {:ok, _} ->
                Repo.delete!(t)
                create_session(user)
              v -> v
            end
        end
    end
  end

  def remove_expired_password_reset_tokens do
    (from t in PasswordResetToken,
    where: t.inserted_at <= datetime_add(^Ecto.DateTime.utc, -1, "hour"))
    |> Repo.delete_all()
  end

  def password_reset_token_changeset(%PasswordResetToken{} = password_reset_token, user) do
    password_reset_token
    |> cast(%{}, [])
    |> put_assoc(:user, user)
    |> put_change(:value, generate_token(user))
    |> validate_required([:value, :user])
    |> unique_constraint(:value)
  end

  defp generate_token(nil), do: nil

  defp generate_token(user),  do: Token.sign(Endpoint, "user", user.id)

end
