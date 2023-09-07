defmodule Bokken.TestUtils do
  @moduledoc """
  Function utilities for testing.
  """
  def forget(struct, field, cardinality \\ :one)

  def forget(struct, fields, cardinality) when is_list(fields) do
    Enum.reduce(fields, struct, fn field, acc ->
      forget(acc, field, cardinality)
    end)
  end

  def forget(struct, field, cardinality) do
    %{
      struct
      | field => %Ecto.Association.NotLoaded{
          __field__: field,
          __owner__: struct.__struct__,
          __cardinality__: cardinality
        }
    }
  end
end
