defmodule Cog.Repository.Bundles do

  use Cog.ObjectRepository

  @not_implemented {:error, "not implemented"}

  @type bundle_error :: {:error, String.t()}
  @type relay_groups :: [Models.RelayGroups]
  @type bundle_versions :: [Models.BundleVersions]
  @type rules :: [Models.Rule]

  @spec install_bundle_version(Models.BundleVersion, boolean()) :: {:ok, Cog.Bundle.OperationSummary} | bundle_error()
  def install_bundle_version(_bundle_version, _dry_run), do: @not_implemented

  @spec uninstall_bundle_version(Models.BundleVersion, boolean()) :: {:ok, Cog.Bundle.OperationSummary} | bundle_error()
  def uninstall_bundle_version(_bundle_version, _dry_run), do: @not_implemented

  @spec enable_bundle_version(Models.BundleVersion) :: :ok | bundle_error()
  def enable_bundle_version(_bundle_version), do: @not_implemented

  @spec disable_bundle_version(Models.BundleVersion) :: :ok | bundle_error()
  def disable_bundle_version(_bundle_version), do: @not_implemented

  @spec assignments_for(Models.BundleVersion | Models.RelayGroup | Models.Relay) :: {:ok, relay_groups()} | {:ok, bundle_versions()} | bundle_error()
  def assignments_for(_entity), do: @not_implemented

  @spec rules_for(Models.CommandVersion) :: {:ok, rules()} | bundle_error()
  def rules_for(_command_version), do: @not_implemented

  @spec add_rule(String.t()) :: :ok | bundle_error()
  def add_rule(_rule_text), do: @not_implemented

  @spec delete_rule(String.t()) :: :ok | bundle_error()
  def delete_rule(_rule_text), do: @not_implemented

end
