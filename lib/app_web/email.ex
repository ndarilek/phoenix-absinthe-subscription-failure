defmodule AppWeb.Email do
  use Bamboo.Phoenix, view: AppWeb.EmailView
  import AppWeb.Router.Helpers

  def password_reset(token) do
    url = "#{url(App.Web.Endpoint)}/password/reset/#{token.value}"
    base_email()
    |> to(token.user.email)
    |> subject("Password Reset")
    |> render(:password_reset, token: token, url: url)
  end

  defp base_email do
    new_email()
    |> put_html_layout({App.LayoutView, "email.html"})
    |> from("support@thewordnerd.info")
  end

end
