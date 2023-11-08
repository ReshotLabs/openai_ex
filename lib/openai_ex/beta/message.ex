defmodule OpenaiEx.Beta.Message do
  @moduledoc """
  This module provides an implementation of the OpenAI messages API. The API reference can be found at https://platform.openai.com/docs/api-reference/messages.

  ## API Fields

  The following fields can be used as parameters when creating or updating a message:

  - `:role`
  - `:content`
  - `:file_ids`
  """

  @api_fields [
    :role,
    :content,
    :file_ids
  ]

  @base_url "/threads"

  @beta_string "assistants=v1"

  @doc """
  Creates a new messages request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the message request.

  ## Returns

  A map containing the fields of the message request.

  Example usage:

      iex> _request = OpenaiEx.Beta.Message.new(role: "user", content: "What's the weather like?")
      %{role: "user", content: "What's the weather like?"}

      iex> _request = OpenaiEx.Beta.Message.new(%{role: "user", content: "What's the weather like?"})
      %{role: "user", content: "What's the weather like?"}
  """

  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{}) do
    args
    |> Map.take(@api_fields)
  end

  @doc """
  Calls the message 'create' endpoint to add a message to a thread.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `thread_id`: The ID of the thread to which the message will be added.
  - `message`: The message request, as a map with keys corresponding to the API fields.

  ## Returns

  A map containing the API response.

  See https://platform.openai.com/docs/api-reference/messages/createMessage for more information.
  """
  def create(openai = %OpenaiEx{}, thread_id, message = %{}) do
    openai
    |> Map.put(:beta, @beta_string)
    |> OpenaiEx.Http.post("#{@base_url}/#{thread_id}/messages", json: message)
  end

  @doc """
  Calls the message 'retrieve' endpoint to get details of a specific message in a thread.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `thread_id`: The ID of the thread.
  - `message_id`: The ID of the message to retrieve.

  ## Returns

  A map containing the fields of the message retrieve response.

  https://platform.openai.com/docs/api-reference/messages/getMessage
  """
  def retrieve(openai = %OpenaiEx{}, thread_id, message_id) do
    openai
    |> Map.put(:beta, @beta_string)
    |> OpenaiEx.Http.get("#{@base_url}/#{thread_id}/messages/#{message_id}")
  end

  def list(openai = %OpenaiEx{}, thread_id) do
    openai
    |> Map.put(:beta, @beta_string)
    |> OpenaiEx.Http.get("#{@base_url}/#{thread_id}/messages")
  end
end
