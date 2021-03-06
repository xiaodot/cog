defmodule Cog.Commands.Sum do
  @moduledoc """
  This command allows the user to sum together a list of numbers

  USAGE
    sum [ARGS ...]

  EXAMPLES
    sum 2 2
    > 4

    sum 2 "-9"
    > -7

    sum 2 24 57 3.7 226.78
    > 313.48
  """
  use Cog.Command.GenCommand.Base, bundle: Cog.embedded_bundle
  require Logger
  import Cog.Helpers, only: [get_number: 1]

  rule "when command is #{Cog.embedded_bundle}:sum allow"

  def handle_message(req, state) do
    {:reply, req.reply_to, %{sum: sum_list(req.args)}, state}
  end

  defp sum_list(nums) do
    accumulate_args(nums, 0)
  end

  defp accumulate_args([], acc) do
    Float.to_string(acc/1, [decimals: 8, compact: true])
  end
  defp accumulate_args([first|rest], acc) do
    num = get_number(first)
    case is_number(num) do
      true -> accumulate_args(rest, num + acc)
      false -> num
    end
  end
end
