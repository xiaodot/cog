defmodule Cog.Repo.Bundle do

  # TODO: Create a Cog.Repository module and eventually dispense with
  # Cog.Repo usage outside of that?

  # TODO: Rewrite existing enable / disable logic in terms of this,
  # interface, defaulting to version 0.0.0 if not specified
  # (eventually, this won't be a default)
  #
  # Get tests in place, then change the implementation

  alias Cog.Repo

  def enable_bundle(%Cog.Models.Bundle{}=bundle) do
    if Bundle.embedded?(bundle) do
      {:error, :embedded_bundle}
    else
      bundle = bundle
      |> Bundle.changeset(%{enabled: true})
      |> Repo.update!

      # TODO: Eventually, do this via event signaling
      Cog.Command.BundleCache.purge(bundle.name)

      {:ok, bundle}
    end
  end

  def disable_bundle(%Cog.Models.Bundle{}=bundle) do
    if Bundle.embedded?(bundle) do
      {:error, :embedded_bundle}
    else
      bundle = bundle
      |> Bundle.changeset(%{enabled: false})
      |> Repo.update!

      # TODO: Eventually, do this via event signaling
      Cog.Command.BundleCache.purge(bundle.name)

      {:ok, bundle}
    end
  end

  # TODO: Currently returns {:ok, :enabled/:disabled}... needs to
  # return something like {:ok, {:enabled, version} |
  # :disabled}... that will require the cache to incorporate version,
  # though.

  # TODO: Just fold the cache into this?

  # TODO: WTH? I have to call this explicitly as
  # Cog.Repo.Bundle.bundle_status/1, but Cog.Repo.bundle_status/1 is unexported!?
  def bundle_status(bundle_name) when is_binary(bundle_name),
    do: Cog.Command.BundleCache.status(bundle_name)

  # TODO: somehow consolidate this with the above?
  def bundle_is_enabled?(%Cog.Models.Bundle{}=bundle),
    do: bundle.enabled

  # require Ecto.Query
  # import Ecto.Query, only: [from: 2]

  # TODO: Create a model for this? Manually messing with
  # Bundle.Version is a code smell

  # TODO: externalize / compose queries?

  # TODO: handle failures (e.g., when a bundle isn't actually in the
  # DB to begin with)

  # def enable_bundle(%Cog.Models.Bundle{name: name, version: version}=bundle) do
  #   Repo.transaction(fn() ->
  #     # remove previously-enabled version of this bundle, if any
  #     disable_bundle(bundle)

  #     {:ok, version} = Cog.Models.Bundle.Version.cast(version)
  #     {1, _} = Repo.insert_all("enabled_bundles",
  #                              [%{name: name, version: version}])
  #     :ok
  #   end)
  #   # TODO: update cache!
  # end

  # def disable_bundle(%Cog.Models.Bundle{name: name}) do
  #   {1, _} = Repo.delete_all(
  #     from(e in "enabled_bundles",
  #          where: name == ^name))
  #   :ok
  #   # TODO: update cache
  # end

  # def is_enabled?(%Cog.Models.Bundle{name: name, version: version}=bundle) do
  #   {:ok, version} = Cog.Models.Bundle.Version.cast(version)
  #   case Repo.one(from(e in "enabled_bundles",
  #                      where: name == ^name
  #                      where: version == ^version)) do
  #     nil -> false
  #     _ -> true
  #   end
  # end

end
