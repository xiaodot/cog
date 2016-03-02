defmodule Cog.Repo.Migrations.BundleStatusWithVersions do
  use Ecto.Migration

  def up do
    create table(:enabled_bundles, primary_key: false) do
      add :name, :string, null: false
      add :version, {:array, :integer}, null: false
    end

    execute """
    ALTER TABLE enabled_bundles
    ADD PRIMARY KEY(name, version)
    """

    execute """
    ALTER TABLE enabled_bundles
    ADD FOREIGN KEY(name, version)
      REFERENCES bundles(name, version)
      ON UPDATE CASCADE ON DELETE CASCADE
    """
  end

  def down do
    drop table(:enabled_bundles)
  end

end
