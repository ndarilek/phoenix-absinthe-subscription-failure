defmodule AppWeb.Plugs.GraphQLUserContext do
  alias App.Accounts
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
      {:ok, macaroon} <- :macaroon.deserialize(token),
      user <- Accounts.user_by_id(macaroon.identifier)
    do
      put_private(conn, :absinthe, %{context: %{macaroon: macaroon, user: user, conn: conn}})
    else
      {:error, reason} -> send_resp(conn, 403, reason)
      _ -> put_private(conn, :absinthe, %{context: %{conn: conn}})
    end
  end

end
