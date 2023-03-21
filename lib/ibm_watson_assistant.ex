defmodule IbmWatsonAssistant do
  @moduledoc """
  Module responsible for assistant messages

  ## Start

   ```elixir
  #  application.ex
  children = [
    {IbmWatsonAssistant, id: "", external_ref_id: "", url: "", version: "", api_key: "", }
  ]
   ```
  """
  use GenServer
  alias IbmWatsonAssistant.IamAuth

  def start_link(config) do
    IamAuth.start_link(config)

    id = Keyword.fetch!(config, :id)
    external_ref_id = Keyword.fetch!(config, :external_ref_id)
    url = Keyword.fetch!(config, :url)
    version = Keyword.fetch!(config, :version)
    access_token = IamAuth.get_token()

    middleware = [
      {Tesla.Middleware.BaseUrl, "#{url}/v2/assistants/#{external_ref_id}"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.BearerAuth, token: access_token}
    ]

    client_http = Tesla.client(middleware)

    GenServer.start_link(
      __MODULE__,
      [
        client_http: client_http,
        version: version
      ],
      name: id
    )
  end

  @doc """
  Module to send message for assistant

  # Example
  ```elixir
  iex> {text, context} = IbmWatsonAssistant.message_stateless id, "Hi"

  {"Hi, how are you?",
  %{
    "global" => %{
      "session_id" => "1fd59cdd-9658-44c3-b0ff-d2ab144ef64f",
      "system" => %{
        "session_start_time" => "2023-03-21T18:49:41.635Z",
        "state" => "eyJza2lsbHMiOlt7InNraWxsX3JlZmVyZW5jZSI6InNlYXJjaCBza2lsbCIsImxhbmd1YWdlIjoieHgiLCJza2lsbF90eXBlIjoic2VhcmNoIiwid29ya2VyX2RlZmluaXRpb25faWQiOiIyOWE0NzZiMi00OTNkLTRlOTQtOGEwOC1mZjY4MWUxNGQ2MjkiLCJza2lsbF9zbmFwc2hvdF9pZCI6bnVsbCwic2tpbGxfc25hcHNob3RfbmFtZSI6bnVsbCwiZGlzYWJsZWQiOnRydWUsImNvbmZpZyI6eyJiYXNpY19hdXRoZW50aWNhdGlvbiI6bnVsbCwiYmVhcmVyX2F1dGhlbnRpY2F0aW9uIjpudWxsLCJwYWdpbmF0aW9uX2VuYWJsZWQiOmZhbHNlLCJ2ZXJzaW9uIjoiMjAxOC0xMi0wMyJ9fSx7InNraWxsX3R5cGUiOiJhY3Rpb24iLCJ3b3JrZXJfZGVmaW5pdGlvbl9pZCI6IjFkMjIxOWI4LWY4M2MtNDI5MS05NTk0LTI3ZjU0MzM0YzljYyIsInNraWxsX3JlZmVyZW5jZSI6ImFjdGlvbnMgc2tpbGwiLCJsYW5ndWFnZSI6InB0LWJyIiwiY29uZmlnIjp7IndvcmtzcGFjZV9pZCI6IjFkMjIxOWI4LWY4M2MtNDI5MS05NTk0LTI3ZjU0MzM0YzljYyIsInNvdXJjZV9hc3Npc3RhbnQiOiIzMDdkOTVkOS0xZGVmLTQyMGQtYjI0Ni0yZGQ2NGFmOGMzYmYiLCJza2lsbF9yZWZlcmVuY2VfaWQiOm51bGx9LCJkaXNhYmxlZCI6ZmFsc2UsInNraWxsX3NuYXBzaG90X2lkIjpudWxsLCJza2lsbF9zbmFwc2hvdF9uYW1lIjpudWxsfSx7InNraWxsX3R5cGUiOiJkaWFsb2ciLCJ3b3JrZXJfZGVmaW5pdGlvbl9pZCI6IjhlZGNlNGY3LTE5ZGYtNDVlOS04Yzk0LWJiYzY3MWEwMmYwNyIsInNraWxsX3JlZmVyZW5jZSI6Im1haW4gc2tpbGwiLCJsYW5ndWFnZSI6InB0LWJyIiwiY29uZmlnIjp7IndvcmtzcGFjZV9pZCI6IjhlZGNlNGY3LTE5ZGYtNDVlOS04Yzk0LWJiYzY3MWEwMmYwNyIsInNvdXJjZV9hc3Npc3RhbnQiOiIzMDdkOTVkOS0xZGVmLTQyMGQtYjI0Ni0yZGQ2NGFmOGMzYmYiLCJza2lsbF9yZWZlcmVuY2VfaWQiOm51bGx9LCJkaXNhYmxlZCI6dHJ1ZSwic2tpbGxfc25hcHNob3RfaWQiOm51bGwsInNraWxsX3NuYXBzaG90X25hbWUiOm51bGx9XSwiYWdlbnRfZGVmaW5pdGlvbl9pZCI6IjU1YzkzOWE0LTA0M2QtNDBiYy1iNDk3LTkxY2ZjZjE2MmFkZCIsInRlbmFudF9pZCI6Ijg1NWVjMmNlLTgxNzItNGUwZi04OWZiLThhOGZiZDMwODVhNSIsImRlZmF1bHRfaW5zdGFuY2UiOnRydWUsImRpc2FibGVfZmFsbGJhY2siOnRydWV9",
        "turn_count" => 1,
        "user_id" => "1fd59cdd-9658-44c3-b0ff-d2ab144ef64f"
      }
    },
    "skills" => %{
      "actions skill" => %{
        "action_variables" => %{},
        "skill_variables" => %{"action" => "show_menu"},
        "system" => %{
          "state" => "eyJzZXNzaW9uX3N0YXJ0X3RpbWUiOiIyMDIzLTAzLTIxVDE4OjQ5OjQxLjYzNVoiLCJzZXNzaW9uX2lkIjoiMWZkNTljZGQtOTY1OC00NGMzLWIwZmYtZDJhYjE0NGVmNjRmIiwic2tpbGxfcmVmZXJlbmNlIjoiYWN0aW9ucyBza2lsbCIsImFzc2lzdGFudF9pZCI6IjU1YzkzOWE0LTA0M2QtNDBiYy1iNDk3LTkxY2ZjZjE2MmFkZCIsImRpZ3Jlc3NlZF9mcm9tIjpudWxsLCJzaGFkb3dfdmFyaWFibGVzIjp7fSwibm9fYWN0aW9uX21hdGNoZXNfY291bnQiOjEsIl9ub2RlX291dHB1dF9tYXAiOnsiYW55dGhpbmdfZWxzZSBzdGVwXzAwMSI6eyIwIjpbMF19fSwiYWN0aW9uX3N0YWNrIjpbXSwic3RyaWtlX2NvdW50IjoxfQ=="
        }
      }
    }
  }}
  ```

  """
  def message_stateless(id, text, context \\ %{}) do
    GenServer.call(id, {:message_stateless, text, context})
  end

  @impl true
  def init(state), do: {:ok, state}

  @impl true
  def handle_call({:message_stateless, text, context}, _from, state) do
    with {:ok, client_http} <- Keyword.fetch(state, :client_http),
         {:ok, version} <- Keyword.fetch(state, :version) do
      case Tesla.post(client_http, "/message?version=#{version}", %{
             input: %{text: text},
             context: context
           }) do
        {:ok,
         %Tesla.Env{
           body: %{
             "output" => %{
               "generic" => generic
             },
             "context" => context
           }
         }} ->
          {:reply,
           {
             generic
             |> Enum.at(0)
             |> Map.fetch!("text"),
             context
           }, state}

        {:error, _} ->
          {
            :reply,
            {
              "Desculpe, ocorreu um erro interno ao tentar acessar o recurso que você solicitou. Por favor, entre em contato com nossa equipe de suporte para que possamos ajudá-lo a resolver o problema. Obrigado pela sua compreensão!",
              %{}
            },
            state
          }
      end
    end
  end
end
