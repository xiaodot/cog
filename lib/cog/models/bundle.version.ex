defmodule Cog.Models.Bundle.Version do
  @moduledoc """
  Transforms a `"major.minor.patch"` SemVer-style string into a
  3-element integer array for storage in the database for the ability
  to easily sort by version.

  Assumes a three-part version string (i.e., `"1.0.0"` vs. `"1.0"` or
  `"1"`), and explicitly does not take into account any kind of
  pre-release version string or build metadata (thus a version of
  `"1.0.0-alpha+001"` is invalid as far as this module is concerned).
  """

  @version_separator "."

  @behaviour Ecto.Type
  def type, do: :array

  def cast(version_string) when is_binary(version_string) do
    case version_string
    |> String.split(@version_separator)
    |> Enum.map(&Integer.parse/1) do
      [{major, ""}, {minor, ""}, {patch, ""}] ->
        {:ok, [major, minor, patch]}
      _ ->
        :error
    end
  end
  def cast([major, minor, patch]=version) when is_integer(major) and
                                               is_integer(minor) and
                                               is_integer(patch) do
    {:ok, version}
  end
  def cast(_),
    do: :error

  def load(version) when is_list(version),
    do: {:ok, Enum.join(version, @version_separator)}

  def dump([_major, _minor, _patch]=version),
    do: {:ok, version}
  def dump(_),
    do: :error

end
