defmodule App.Accounts.PasswordResetToken do
  alias App.Accounts.User
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "password_reset_tokens" do
    field :value, :string
    belongs_to :user, User

    timestamps(updated_at: false)
  end

end
