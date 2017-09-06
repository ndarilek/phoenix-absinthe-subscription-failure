defmodule App.Accounts.PasswordResetTokenSweeper do
  use GenServer
  alias App.Accounts

  def start_link do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(nil) do
    schedule_work()
    {:ok, nil}
  end

  def handle_info(:work, nil) do
    Accounts.remove_expired_password_reset_tokens()
    schedule_work()
    {:noreply, nil}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 1*60*60*1000) # In 1 hour
  end

end
