defmodule Bokken.Factories.DocumentsFactory do
  @moduledoc """
  Factories to generate documents related structs
  """
  defmacro __using__(_opts) do
    quote do
      alias Bokken.Documents.File
      alias Faker.File, as: FileGenerator

      def file_factory do
        document = %{
          content_type: "image/png",
          file_name: "avatar.png",
          path: "priv/faker/images/avatar.png"
        }

        %File{
          title: FileGenerator.file_name(),
          document: document,
          user: build(:mentor)
        }
      end
    end
  end
end
