defmodule OpenaiEx.Beta.Run do
  @moduledoc """
  This module provides an implementation of the OpenAI runs API. The API reference can be found at https://platform.openai.com/docs/api-reference/runs.

  ## API Fields

  The following fields can be used as parameters when creating or interacting with a run:

  - `:assistant_id`
  - `:model`
  - `:instructions`
  - `:tools`
  """

  @api_fields [
    :assistant_id,
    :model,
    :instructions,
    :tools
  ]

  @base_url "/threads"

  @beta_string "assistants=v1"

  @doc """
  Creates a new run request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the run request.

  ## Returns

  A map containing the fields of the run request.

  Example usage:

      iex> _request = OpenaiEx.Beta.Run.new(assistant_id: "asst_xxx", model: "gpt-4")
      %{assistant_id: "asst_xxx", model: "gpt-4"}

      iex> _request = OpenaiEx.Beta.Run.new(%{assistant_id: "asst_xxx", model: "gpt-4"})
      %{assistant_id: "asst_xxx", model: "gpt-4"}
  """

  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{}) do
    args
    |> Map.take(@api_fields)
  end

  @doc """
  Calls the run 'create' endpoint to execute a run on a thread.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `thread_id`: The ID of the thread on which the run will be executed.
  - `run`: The run request, as a map with keys corresponding to the API fields.

  ## Returns

  A map containing the API response.

  See https://platform.openai.com/docs/api-reference/runs/createRun for more information.
  """
  def create(openai = %OpenaiEx{}, thread_id, run = %{}) do
    openai
    |> Map.put(:beta, @beta_string)
    |> OpenaiEx.Http.post("#{@base_url}/#{thread_id}/runs", json: run)
  end

  @doc """
  Retrieves the status and details of a specific run within a thread.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `thread_id`: The ID of the thread.
  - `run_id`: The ID of the run to retrieve.

  ## Returns

  A map containing the fields of the run retrieve response.

  https://platform.openai.com/docs/api-reference/runs/getRun
  """
  def retrieve(openai = %OpenaiEx{}, thread_id, run_id) do
    openai
    |> Map.put(:beta, @beta_string)
    |> OpenaiEx.Http.get("#{@base_url}/#{thread_id}/runs/#{run_id}")
  end

  @doc """
  Retrieves a list of runs within a thread.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `thread_id`: The ID of the thread.

  ## Returns

  A map containing the fields of the run list response.

  https://platform.openai.com/docs/api-reference/runs/listRuns
  """
  def list(openai = %OpenaiEx{}, thread_id) do
    openai
    |> Map.put(:beta, @beta_string)
    |> OpenaiEx.Http.get("#{@base_url}/#{thread_id}/runs")
  end

  @doc """
  Cancels a run that is in progress.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `thread_id`: The ID of the thread to which this run belongs.
  - `run_id`: The ID of the run to cancel.

  ## Returns

  A map containing the fields of the modified run object.

  https://platform.openai.com/docs/api-reference/runs/cancelRun
  """
  def cancel_run(openai = %OpenaiEx{}, thread_id, run_id) do
    openai
    |> Map.put(:beta, @beta_string)
    |> OpenaiEx.Http.post("#{@base_url}/#{thread_id}/runs/#{run_id}/cancel", json: %{})
  end

  @doc """
  Submits tool outputs to a run that requires action.

  ## Arguments

  - `openai`: The OpenAI configuration.
  - `thread_id`: The ID of the thread to which this run belongs.
  - `run_id`: The ID of the run that requires the tool output submission.
  - `tool_outputs`: A list of tool outputs being submitted.

  ## Returns

  A map containing the fields of the modified run object.

  See https://api.openai.com/docs/api-reference/runs/submitToolOutputs for more information.
  """
  def submit_tool_outputs(openai = %OpenaiEx{}, thread_id, run_id, tool_outputs) do
    openai
    |> Map.put(:beta, @beta_string)
    |> OpenaiEx.Http.post("#{@base_url}/#{thread_id}/runs/#{run_id}/submit_tool_outputs",
      json: %{tool_outputs: tool_outputs}
    )
  end
end
