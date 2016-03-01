defmodule Cog.Repo.Migrations.BundleVersions do
  use Ecto.Migration

  def change do
    alter table(:bundles) do
      add :version, {:array, :integer}, default: fragment("ARRAY[0,0,0]"), null: false
    end
    create unique_index(:bundles, [:name, :version])
    drop unique_index(:bundles, [:name])
  end
end
