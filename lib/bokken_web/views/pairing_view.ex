defmodule BokkenWeb.PairingView do
  use BokkenWeb, :view

  alias BokkenWeb.PairingView

  def render("index.json", %{lectures: lectures}) do
    %{data: render_many(lectures, PairingView, "pairing.json")}
  end

  def render("create.json", %{lectures: lectures}) do
    %{data: render_many(lectures, PairingView, "pairing.json")}
  end

  def render("pairing.json", %{pairing: {:ok, lecture}}) do
    %{
      event_id: lecture.event_id,
      mentor_id: lecture.mentor_id,
      ninja_id: lecture.ninja_id,
      notes: lecture.notes,
      attendance: lecture.attendance
    }
  end
end
