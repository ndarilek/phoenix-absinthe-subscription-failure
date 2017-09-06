defmodule App.Accounts.User do
  alias App.Accounts.PasswordResetToken
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :username, :string
    field :password, Comeonin.Ecto.Password
    has_many :password_reset_tokens, PasswordResetToken

    timestamps()
  end

end
