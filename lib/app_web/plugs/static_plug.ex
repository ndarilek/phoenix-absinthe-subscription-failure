defmodule AppWeb.Plugs.StaticPlug do
  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts), do: send_file(conn, 200, "priv/static/index.html")

end
