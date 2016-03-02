defmodule Cog.Models.Bundle.Status do
  # Temporary home of bundle status toggling logic, until such time as
  # the logic on whether or not to dispatch based on bundle status is
  # moved into the executor. Then this module can be simplified / go away / be merged
  # back into `Cog.Models.Bundle`.

  alias Cog.Repo

  @doc """
  Gives the name of the bundle, it's current activation status, and
  a list of relays currently running the bundle (if any).

  Example:

      %{bundle: "github",
        status: "enabled",
        relays: ["44a92066-b1ae-4456-8e6a-4f212bed3180"]}

  """
  def current(bundle) do
    %{bundle: bundle.name,
      relays: Cog.Relay.Relays.relays_running(bundle.name),
      status: bool_to_status(Repo.bundle_is_enabled?)}
  end

  defp bool_to_status(true), do: :enabled
  defp bool_to_status(false), do: :disabled

end
