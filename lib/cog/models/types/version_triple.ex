defmodule Cog.Models.Types.VersionTriple do

  @behaviour Ecto.Type

  def type(), do: __MODULE__

  def cast(text), do: Version.parse(text)

  def dump(%Version{major: major, minor: minor, patch: patch}) do
    {:ok, [major, minor, patch]}
  end
  def dump(_), do: :error

  def load([major, minor, patch]) do
    {:ok, %Version{major: major, minor: minor, patch: patch}}
  end
  def load(%Ecto.Query.Tagged{type: :version_triple, value: value}), do: load(value)
  def load(_), do: :error

end
