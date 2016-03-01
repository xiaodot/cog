defmodule Cog.Repo.Migrations.EmbeddedBundleUpgradeFrom02 do

  use Ecto.Migration
  alias Cog.Models.Bundle
  alias Cog.Models.Command
  alias Cog.Repo
  require Ecto.Query
  require Logger
  import Ecto.Query, only: [from: 2]

  # This is a workaround for the fact that we currently have no clear
  # upgrade path for bundles. Here, we do some brute-force upgrading
  # by munging the database directly.
  #
  # This is explicitly targeted at upgrading from version 0.2 to 0.3
  def up do
    Repo.transaction(fn() ->
      case Repo.get_by(Bundle, name: Cog.embedded_bundle) do
        %Bundle{id: embedded_id}=embedded ->
          case Repo.one(from(c in Command,
                             join: b in assoc(c, :bundle),
                             where: b.id == ^embedded_id,
                             where: c.name == "alias")) do
            %Command{}=alias_command ->
              current_embedded_config = Cog.Bundle.Embedded.embedded_bundle

              # From 0.2 to 0.3, the documentation for alias has
              # changed
              alias_documentation = current_embedded_config
              |> Map.get("commands")
              |> Enum.filter(fn(c) -> c["name"] == "alias" end)
              |> List.first
              |> Map.get("documentation")

              Repo.update!(%Command{alias_command | documentation: alias_documentation})

              # Update Embedded bundle config
              Logger.info("Updating embedded bundle config")

              embedded
              |> Bundle.changeset(%{config_file: current_embedded_config})
              |> Repo.update!
            _ ->
              # Not making any attempt to upgrade from anything other
              # than 0.2
              :ok
          end
      nil ->
        # If the embedded bundle does not exist, then this is a fresh
        # installation and we don't need to do anything
        :ok
      end
    end)
  end

  def down do
    # No downgrade required
    :ok
  end

end
