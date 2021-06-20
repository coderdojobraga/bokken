defmodule Bokken.Schema do
  @moduledoc """
  The application Schema for all the modules, providing Ecto.UUIDs as default
  id.
  """

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      use Waffle.Ecto.Schema
      import Ecto.Changeset
      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end
end
