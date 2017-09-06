defmodule AppWeb.PageController do
  use AppWeb, :controller

  def index(conn, _params), do: send_file(conn, 200, "priv/static/index.html")

end
