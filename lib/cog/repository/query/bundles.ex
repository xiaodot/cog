defmodule Cog.Repository.Query.Bundles do

  use Cog.Models

  import Ecto.Query, only: [from: 2,
                            where: 3,
                            join: 5]

  def rules_for_enabled_version(bundle, command) do
    from b in Bundle,
    join: bv in BundleVersion, on: bv.bundle_id == b.id,
    join: cv in CommandVersion, on: cv.bundle_id == bv.id,
    join: vr in VersionedRule, on: vr.command_id == cv.id,
    where: b.name == ^bundle,
    where: cv.name == ^command,
    where: bv.enabled == true,
    where: vr.enabled == true
  end

end
