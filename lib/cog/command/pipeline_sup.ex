defmodule Cog.Command.PipelineSup do
  use Supervisor

  alias Cog.Command

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [worker(Command.PermissionsCache, []),
                worker(Cog.TemplateCache, []),
                supervisor(Command.Pipeline.ExecutorSup, []),
                worker(Command.Pipeline.Initializer, [])]
    supervise(children, strategy: :one_for_one)
  end

end
