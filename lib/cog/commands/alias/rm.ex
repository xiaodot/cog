defmodule Cog.Commands.Alias.Rm do
  alias Cog.Repo
  alias Cog.Commands.Helpers

  @moduledoc """
  Removes an alias. Subcommand for alias.
  If a visibility is not passed the user visibility is first searched and then
  the site visibility.

  USAGE
    alias rm <alias-name>

  EXAMPLE
    alias rm my-awesome-alias
    > Successfully removed 'user:my-awesome-alias'

  """

  @doc """
  Entry point for removing an alias.

  Takes a cog request and an argument list.
  Returns {:ok, <msg>} on success and {:error, <err>} on failure.
  """
  def rm_command_alias(req, arg_list) do
    user_id = req.user["id"]

    case Helpers.get_args(arg_list, 1) do
      {:ok, [alias]} ->
        case Helpers.get_command_alias(user_id, alias) do
          nil ->
            {:error, {:alias_not_found, alias}}
          command_alias ->
            case Repo.delete(command_alias) do
              {:ok, removed_alias} ->
                {:ok, "alias-rm", Helpers.jsonify(removed_alias)}
              {:error, %{errors: errors}} ->
                {:error, {:db_errors, errors}}
            end
        end
        error ->
          error
    end
  end

end
