defmodule Cog.Commands.Alias do
  use Cog.Command.GenCommand.Base, bundle: Cog.embedded_bundle
  alias Cog.Commands.Alias
  alias Cog.Commands.Helpers

  @moduledoc """
  Manages aliases

  USAGE
    alias <subcommand>


  SUBCOMMANDS
    new <alias-name> <alias-definition>             creates a new alias visible to the creating user.
    mv <alias-name> <site | user>:[new-alias-name]  moves aliases between user and site visibility. Optionally renames aliases.
    rm <alias-name>                                 Removes aliases
    ls [pattern]                                    Returns the list of aliases optionally filtered by pattern. Pattern support basic wildcards with '*'.


  EXAMPLES
    alias new my-awesome-alias "echo \"My Awesome Alias\""
    > user:my-awesome-alias has been created

    alias mv my-awesome-alias site:awesome-alias
    > Moved user:my-awesome-alias to site:awesome-alias

    alias rm awesome-alias
    > Removed site:awesome-alias

    alias ls
    > Name: 'my-awesome-alias'
      Visibility: 'user'
      Pipeline: 'echo my-awesome-alias'

      Name: 'my-other-awesome-alias'
      Visibility: 'site'
      Pipeline: 'echo my-other-awesome-alias'
  """

  rule "when command is #{Cog.embedded_bundle}:alias allow"

  def handle_message(req, state) do
    {subcommand, args} = get_subcommand(req.args)

    result = case subcommand do
      "new" ->
        Alias.New.create_new_user_command_alias(req, args)
      "mv" ->
        Alias.Mv.mv_command_alias(req, args)
      "rm" ->
        Alias.Rm.rm_command_alias(req, args)
      "ls" ->
        Alias.Ls.list_command_aliases(req, args)
      nil ->
        {:error, :no_subcommand}
      invalid ->
        {:error, {:unknown_subcommand, invalid}}
    end

    case result do
      {:ok, template, data} ->
        {:reply, req.reply_to, template, data, state}
      {:error, err} ->
        {:error, req.reply_to, Helpers.error(err), state}
    end
  end

  defp get_subcommand([]),
    do: {nil, []}
  defp get_subcommand([subcommand | args]),
    do: {subcommand, args}

end
