defmodule HelloWorldWeb.ProjectController do
  use HelloWorldWeb, :controller

  alias HelloWorld.HelloProjects
  alias HelloWorld.HelloProjects.Project

  action_fallback HelloWorldWeb.FallbackController

  def index(conn, _params) do
    projects = HelloProjects.list_projects()
    render(conn, "index.json", projects: projects)
  end

  def create(conn, %{"project" => project_params}) do
    with {:ok, %Project{} = project} <- HelloProjects.create_project(project_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.project_path(conn, :show, project))
      |> render("show.json", project: project)
    end
  end

  def show(conn, %{"id" => id}) do
    project = HelloProjects.get_project!(id)
    render(conn, "show.json", project: project)
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    project = HelloProjects.get_project!(id)

    with {:ok, %Project{} = project} <- HelloProjects.update_project(project, project_params) do
      render(conn, "show.json", project: project)
    end
  end

  def delete(conn, %{"id" => id}) do
    project = HelloProjects.get_project!(id)

    with {:ok, %Project{}} <- HelloProjects.delete_project(project) do
      send_resp(conn, :no_content, "")
    end
  end
end
