defmodule HelloWorld.HelloProjects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :name, :string
    field :status, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :type, :status])
    |> validate_required([:name, :type, :status])
    |> unique_constraint(:name)
  end
end
