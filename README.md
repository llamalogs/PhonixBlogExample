# About

https://llamalogs.com

This is an example Phoenix project to go along with the Llama Logs blog post found here:
https://dev.to/bakenator/visualize-your-elixir-phoenix-app-with-llama-logs-43nn

# Running

The Account Key and Graph Name in the application.ex file will need to updated with valid values from your Llama Logs account.

Then the server can be set up with the standard Phoenix starting commands.
`mix ecto.create`
`iex -S mix phx.server`

# Test Events

In order to trigger test events for the Llama Logs graph, a test script has been created.
This script can be run repeatedly to generate events.
`mix run simulation_script.ex`