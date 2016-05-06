defmodule Cog.Models.CommandVersion do
  use Cog.Model
  use Cog.Models

  require Logger

  schema "commands" do
    field :name, :string
    field :documentation, :string

    belongs_to :bundle_version, BundleVersion

    has_many :rules, Rule
    has_many :options, CommandOption
  end

  @required_fields ~w(name bundle_version_id)
  @optional_fields ~w(documentation)

  @doc """
  Create a new changeset for a command, associating it with its parent
  bundle (which must already exist in the database).

  Does _not_ insert anything into the database.
  """
  def build_new(%Bundle{id: _}=bundle, params) do
    bundle
    |> Ecto.Model.build(:commands)
    |> changeset(params)
  end

  @doc """
  Splits a fully qualified command name into namespace and command
  name.
  """
  def split_name(name) do
    case String.split(name, "::", parts: 2) do
      [bundle, command] ->
        {bundle, command}
      [_] ->
        case String.split(name, ":", parts: 2) do
          [bundle, command] ->
            {bundle, command}
          [_] ->
            {name, name}
        end
    end
  end

  @doc """
  Get the fully qualified name; depends on bundle being preloaded.
  """
  def full_name(%__MODULE__{}=command) do
    "#{command.bundle.name}:#{command.name}"
  end

  def changeset(model, params) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:name, ~r/\A[A-Za-z0-9\_\-\.]+\z/)
    |> foreign_key_constraint(:bundle_id)
    |> unique_constraint(:bundle, name: "bundled_command_name")
  end

end
