defmodule HelloWorld.HelloProjectsTest do
  use HelloWorld.DataCase

  alias HelloWorld.HelloProjects

  describe "projects" do
    alias HelloWorld.HelloProjects.Project

    @valid_attrs %{name: "some name", status: "some status", type: "some type"}
    @update_attrs %{name: "some updated name", status: "some updated status", type: "some updated type"}
    @invalid_attrs %{name: nil, status: nil, type: nil}

    def project_fixture(attrs \\ %{}) do
      {:ok, project} =
        attrs
        |> Enum.into(@valid_attrs)
        |> HelloProjects.create_project()

      project
    end

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert HelloProjects.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert HelloProjects.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project" do
      assert {:ok, %Project{} = project} = HelloProjects.create_project(@valid_attrs)
      assert project.name == "some name"
      assert project.status == "some status"
      assert project.type == "some type"
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = HelloProjects.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      assert {:ok, %Project{} = project} = HelloProjects.update_project(project, @update_attrs)
      assert project.name == "some updated name"
      assert project.status == "some updated status"
      assert project.type == "some updated type"
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = HelloProjects.update_project(project, @invalid_attrs)
      assert project == HelloProjects.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = HelloProjects.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> HelloProjects.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = HelloProjects.change_project(project)
    end
  end
end
