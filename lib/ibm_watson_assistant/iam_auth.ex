defmodule IbmWatsonAssistant.IamAuth do
  @moduledoc """
  Module responsible for iam authentication in the ibm api
  """
  use Tesla
  use Agent

  require Logger

  @url "https://iam.cloud.ibm.com/identity/token"
  @api_key System.get_env("ASSISTANT_API_KEY")

  plug(Tesla.Middleware.BaseUrl, @url)
  plug(Tesla.Middleware.JSON)

  def start_link(config) do
    api_key = Keyword.fetch!(config, :api_key)

    Agent.start_link(
      fn ->
        [api_key: api_key]
      end,
      name: __MODULE__
    )
  end

  def get_token() do
    with state <- Agent.get(__MODULE__, & &1) do
      case Keyword.fetch(state, :access_token) do
        {:ok, access_token} ->
          access_token

        _ ->
          with {:ok, api_key} <- Keyword.fetch(state, :api_key) do
            @url
            |> post!("grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey=#{api_key}")
            |> then(fn %Tesla.Env{body: %{"access_token" => access_token}} ->
              Agent.update(__MODULE__, fn state ->
                Keyword.put(state, :access_token, access_token)
              end)

              get_token()
            end)
          end
      end
    end
  end
end
