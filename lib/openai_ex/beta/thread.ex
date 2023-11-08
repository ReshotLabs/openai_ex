defmodule OpenaiEx.Beta.Thread do
  @moduledoc """
  This module provides an implementation of the OpenAI threads API. The API reference can be found at https://platform.openai.com/docs/api-reference/threads.

  ## API Fields

  The following fields can be used as parameters when creating or updating a thread:

  - `:messages`
  """

  @api_fields [
    :messages
  ]

  @threads_url "/threads"

  @beta_string "assistants=v1"

  @doc """
  Creates a new threads request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the thread request.

  ## Returns

  A map containing the fields of the thread request.

  Example usage:

      iex> _request = OpenaiEx.Beta.Thread.new(messages: [%{role: "user", content: "Hello, world!"}])
      %{messages: [%{role: "user", content: "Hello, world!"}]}

      iex> _request = OpenaiEx.Beta.Thread.new(%{messages: [%{role: "user", content: "Hello, world!"}]})
      %{messages: [%{role: "user", content: "Hello, world!"}]}
  """

  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{}) do
    args
    |> Map.take(@api_fields)
  end

  @doc """
  Calls the thread 'create' endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `thread`: The thread request, as a map with keys corresponding to the API fields.

  ## Returns

  A map containing the API response.

  See https://platform.openai.com/docs/api-reference/threads/createThread for more information.
  """
  def create(openai = %OpenaiEx{}, thread = %{}) do
    openai
    |> Map.put(:beta, @beta_string)
    |> OpenaiEx.Http.post(@threads_url, json: thread)
  end

  @doc """
  Calls the thread retrieve endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `thread_id`: The ID of the thread to retrieve.

  ## Returns

  A map containing the fields of the thread retrieve response.

  https://platform.openai.com/docs/api-reference/threads/getThread
  """
  def retrieve(openai = %OpenaiEx{}, thread_id) do
    openai
    |> Map.put(:beta, @beta_string)
    |> OpenaiEx.Http.get("#{@threads_url}/#{thread_id}")
  end

  @doc """
  Deletes a thread.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `thread_id`: The ID of the thread to delete.

  ## Returns

  A map containing the fields of the thread delete response.

  https://platform.openai.com/docs/api-reference/threads/deleteThread
  """
  def delete(openai = %OpenaiEx{}, thread_id) do
    openai
    |> Map.put(:beta, @beta_string)
    |> OpenaiEx.Http.delete("#{@threads_url}/#{thread_id}")
  end
end
