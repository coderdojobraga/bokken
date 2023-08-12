defmodule Bokken.MentorJSONTest do
  use Bokken.DataCase

  import Bokken.Factory

  alias Bokken.Uploaders.Avatar
  alias BokkenWeb.MentorJSON

  test "index" do
    mentors = build_list(5, :mentor)
    rendered_mentors = MentorJSON.index(%{mentors: mentors, current_user: nil})

    assert rendered_mentors == %{data: for(mentor <- mentors, do: MentorJSON.data(mentor, nil))}
  end

  test "show" do
    mentor = build(:mentor)
    rendered_mentor = MentorJSON.show(%{mentor: mentor, current_user: nil})

    assert rendered_mentor == %{data: MentorJSON.data(mentor, nil)}
  end

  test "data" do
    mentor = build(:mentor) |> forget(:skills)
    rendered_mentor = MentorJSON.data(mentor, mentor.user)

    assert rendered_mentor == %{
             id: mentor.id,
             photo: Avatar.url({mentor.photo, mentor}, :thumb),
             first_name: mentor.first_name,
             last_name: mentor.last_name,
             socials: mentor.socials,
             since: mentor.inserted_at,
             birthday: mentor.birthday,
             major: mentor.major,
             mobile: mentor.mobile,
             t_shirt: mentor.t_shirt,
             trial: mentor.trial
           }
  end
end
