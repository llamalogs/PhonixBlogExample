IO.inspect "hello there"

Application.ensure_all_started(:inets)
Application.ensure_all_started(:ssl)

defmodule SimScript do
    def random_string(length) do
        :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
    end

    def get_random_name() do
        "test_project_#{random_string(5)}"
    end

    def make_projects(names, type) do
        Enum.each(names, fn name -> SimScript.make_project(name, type) end)
    end

    def make_project(name, type) do
        {_status, body} = Jason.encode(%{project: %{name: name, status: "not started", type: type}})
        request = {'http://localhost:4000/api/projects', [], 'application/json', body}
        
        {:ok, {{'HTTP/1.1', _return_code, _return_status}, _headers, _body}} =
        :httpc.request(:post, request, [], [])

        IO.inspect "Created Project #{name}"
    end

    def view_projects(names) do
        Enum.each(names, fn name -> SimScript.view_project(name) end)
    end

    def view_project(name) do
        name_chars = String.to_charlist(name)
        {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, _body}} =
        :httpc.request(:get, {'http://localhost:4000/api/projects/' ++ name_chars, []}, [], [])

        IO.inspect "Viewed Project #{name}"
    end

    def update_projects(names, status) do
        Enum.each(names, fn name -> SimScript.update_project(name, status) end)
    end

    def update_project(name, status) do
        name_chars = String.to_charlist(name)
        {_status, body} = Jason.encode(%{project: %{status: status}})
        request = {'http://localhost:4000/api/projects/' ++ name_chars, [], 'application/json', body}
        
        {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, _body}} =
        :httpc.request(:put, request, [], [])

        IO.inspect "Updated Project #{name} with #{status} status"
    end
end

random_internal_names = 
    Stream.repeatedly(fn -> SimScript.get_random_name() end) 
    |> Enum.take(10)

SimScript.make_projects(random_internal_names, "Internal")

random_external_names = 
    Stream.repeatedly(fn -> SimScript.get_random_name() end) 
    |> Enum.take(5)

# creating some example projects
SimScript.make_projects(random_external_names, "External")
# creating errors by trying to make projects with the same names
SimScript.make_projects(random_external_names, "External")
# sending get requests for each project
SimScript.view_projects(random_internal_names)
SimScript.view_projects(random_external_names)
# updating the status of each project
SimScript.update_projects(random_internal_names, "in progress")
SimScript.update_projects(random_external_names, "in progress")