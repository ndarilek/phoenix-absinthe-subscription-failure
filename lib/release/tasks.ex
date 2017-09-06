defmodule Release.Tasks do  
  def migrate do
    {:ok, _} = Application.ensure_all_started(:app)
    path = Application.app_dir(:app, "priv/repo/migrations")
    Ecto.Migrator.run(App.Repo, path, :up, all: true)
  end
end
