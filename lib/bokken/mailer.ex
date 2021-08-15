defmodule Bokken.Mailer do
  @moduledoc """
  A mailer module providing functionality to deliver emails.
  """
  use Swoosh.Mailer, otp_app: :bokken
end
