defmodule AppWeb.API.Helpers do

  def to_graphql_errors(changeset, message \\ "Error in mutation") do
    errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    Map.put(errors, :message, message)
  end

end
