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
      LlamaLogs.log(%{sender: "User", receiver: project.type})
      LlamaLogs.log(%{sender: project.type, receiver: "#{project.type} Create"})
      LlamaLogs.log(%{sender: "#{project.type} Create", receiver: "Database"})

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.project_path(conn, :show, project))
      |> render("show.json", project: project)
    else 
      result -> 
        LlamaLogs.log(%{sender: "User", receiver: project_params["type"]})
        LlamaLogs.log(%{sender: project_params["type"], receiver: "#{project_params["type"]} Create"})
        LlamaLogs.log(%{sender: "#{project_params["type"]} Create", receiver: "Database", is_error: true})
        conn 
        |> put_status(:bad_request)
        |> render("error.json", %{})
    end
  end

  def show(conn, %{"id" => name}) do
    project = HelloProjects.get_project_by_name(name)

    LlamaLogs.log(%{sender: "User", receiver: project.type})
    LlamaLogs.log(%{sender: project.type, receiver: "#{project.type} Show"})
    LlamaLogs.log(%{sender: "Database", receiver: "#{project.type} Show"})

    render(conn, "show.json", project: project)
  end

  def update(conn, %{"id" => name, "project" => project_params}) do
    project = HelloProjects.get_project_by_name(name)

    with {:ok, %Project{} = project} <- HelloProjects.update_project(project, project_params) do

      LlamaLogs.log(%{sender: "User", receiver: project.type})
      LlamaLogs.log(%{sender: project.type, receiver: "#{project.type} Update"})
      LlamaLogs.log(%{sender: "#{project.type} Update", receiver: "Database"})

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
