defmodule Bokken.UserHasNotPermissionError do
  defexception [:message, plug_status: 403]
end
