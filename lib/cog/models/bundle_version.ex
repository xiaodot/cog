defmodule Cog.Models.BundleVersion do
  use Cog.Model

  schema "bundle_versions" do
    field :version, VersionTriple
    field :config_file, :map
    field :enabled, :boolean, default: false

    belongs_to :bundle, Bundle

    has_many :group_assignments, RelayGroupAssignment, foreign_key: :bundle_version_id
    has_many :relay_groups, through: [:group_assignments, :group]
    has_many :commands, CommandVersion, foreign_key: :bundle_version_id

    timestamps
  end

  @required_fields ~w(version config_file bundle_id)
  @optional_fields ~w(enabled)

end
