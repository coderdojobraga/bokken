defmodule BokkenWeb.PairingView do
  use BokkenWeb, :view
  
  alias Bokken.Events
  alias BokkenWeb.PairingView
  
  def render("index.json", %{lectures: lectures}) do
    IO.inspect lectures
    %{data: render_many(lectures, PairingView, "pairing.json")}
  end

  def render("pairing.json", %{lecture: lecture}) do
    %{event_id: lecture.event_id}
  end
end
