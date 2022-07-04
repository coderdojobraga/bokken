defmodule Bokken.Events.Event do
  @moduledoc """
  An event of CoderDojo
  """
  use Bokken.Schema

  alias Bokken.Accounts.{Mentor, Ninja}
  alias Bokken.Events.{Lecture, Location, Team}

  @required_fields [:team_id, :location_id, :spots_available, :online, :start_time, :end_time,
    :enrollments_open, :enrollments_close]
  @optional_fields [:notes, :title]

  schema "events" do
    field :title, :string
    field :spots_available, :integer
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime
    field :enrollments_open, :utc_datetime
    field :enrollments_close, :utc_datetime
    field :online, :boolean
    field :notes, :string

    belongs_to :location, Location, foreign_key: :location_id
    belongs_to :team, Team, foreign_key: :team_id

    many_to_many :ninjas, Ninja, join_through: Lecture
    many_to_many :mentors, Mentor, join_through: Lecture

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_number(:spots_available, greater_than_or_equal_to: 0)
    |> assoc_constraint(:team)
    |> assoc_constraint(:location)
    |> validate_dates()
  end

  defp validate_dates(changeset) do
    starts_on = get_field(changeset, :start_time)
    ends_on = get_field(changeset, :end_time)
    enrollments_open  = get_field(changeset, :enrollments_open)
    enrollments_close = get_field(changeset, :enrollments_close)

    if Date.compare(starts_on, ends_on) == :gt do
      add_error(changeset, :end_time, "must be greater than start_time")
    else
      if Date.compare(enrollments_open, enrollments_close) == :gt do
        add_error(changeset, :enrollments_close, "must be greater than enrollments_open")
      else
        if Date.compare(enrollments_close, starts_on) == :gt do
          add_error(changeset, :enrollments_close, "must be smaller than start_time")
        else
          changeset
        end
      end
    end
  end
end
