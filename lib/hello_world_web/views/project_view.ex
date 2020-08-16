defmodule HelloWorldWeb.ProjectView do
  use HelloWorldWeb, :view
  alias HelloWorldWeb.ProjectView

  def render("index.json", %{projects: projects}) do
    %{data: render_many(projects, ProjectView, "project.json")}
  end

  def render("show.json", %{project: project}) do
    %{data: render_one(project, ProjectView, "project.json")}
  end

  def render("error.json", %{}) do 
    %{}
  end

  def render("project.json", %{project: project}) do
    %{id: project.id,
      name: project.name,
      type: project.type,
      status: project.status}
  end
end
