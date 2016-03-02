defmodule Cog.Bundle.Canonicalize do
  @moduledoc """

  Defines a canonical structure for a bundle configuration map.

  A key aspect of this is ensuring that lists that are effectively
  sets (i.e., order has no intrinsic meaning) are sorted.

  """
  def canonicalize(bundle_config) do
    bundle_config
    # TODO: pull this from the bundle model somehow
    |> present_or_defaulted("version", "0.0.0")
    |> canonicalize_commands
    |> ensure_sorted("permissions")
    |> ensure_sorted("templates")
    |> ensure_sorted("rules")
  end

  defp canonicalize_commands(config) do
    Map.update(config, "commands", [], fn(cs) ->
      cs
      |> Enum.map(&canonicalize_command/1)
      |> Enum.sort
    end)
  end

  defp canonicalize_command(command) do
    command
    |> Map.delete("version")
    |> ensure_sorted("options")
  end

  defp present_or_defaulted(map, key, default),
    do: Map.update(map, key, default, &(&1))

  # Ensure that a list exists at `key` in `map`, and that it is
  # sorted.
  defp ensure_sorted(map, key),
    do: Map.update(map, key, [], &Enum.sort/1)

end
