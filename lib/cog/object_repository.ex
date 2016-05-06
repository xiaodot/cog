defmodule Cog.ObjectRepository do

  defmacro __using__(_) do
    query_mod = make_query_module_name(__CALLER__.module)
    quote do
      use Cog.Models
      alias Cog.Repo
      alias unquote(query_mod)
    end
  end

  # Given a repository module named `Cog.Repository.Foo` build the corresponding
  # query module name `Cog.Repository.Query.Foo`
  defp make_query_module_name(caller) do
    ["Elixir", "Cog", "Repository"|rest] = Atom.to_string(caller)
                                          |> String.split(".")

    Enum.join(["Elixir", "Cog", "Repository", "Query"|rest], ".") |> String.to_atom
  end

end
