defmodule Bokken.Curriculum do
  @moduledoc """
  The Curriculum context.
  """

  import Ecto.Query, warn: false
  alias Bokken.Repo

  alias Bokken.Curriculum.{MentorSkill, NinjaSkill, Skill}

  @doc """
  Gets a single skill.

  Raises `Ecto.NoResultsError` if the Skill does not exist.

  ## Examples

      iex> get_skill!(123)
      %Skill{}

      iex> get_skill!(456)
      ** (Ecto.NoResultsError)

  """
  def get_skill!(id) do
    Repo.get!(Skill, id)
  end

  @doc """
  Returns the list of skills.
  ## Examples
      iex> list_skills()
      [%Skill{}, ...]
  """
  def list_skills do
    Skill
    |> Repo.all()
  end

  @doc """
  Creates a skill.

  ## Examples

      iex> create_skill(%{field: value})
      {:ok, %Skill{}}

      iex> create_skill(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_skill(attrs \\ %{}) do
    %Skill{}
    |> Skill.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a skill.

  ## Examples

      iex> update_skill(%Skill{}, %{field: value})
      {:ok, %Skill{}}

      iex> update_skill(%Skill{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_skill(%Skill{} = skill, attrs \\ %{}) do
    skill
    |> Skill.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a  skill.

  ## Examples

      iex> delete_skill(skill)
      {:ok, %Skill{}}

      iex> delete_skill(skill)
      {:error, %Ecto.Changeset{}}
  """
  def delete_skill(%Skill{} = skill) do
    Repo.delete(skill)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking skill changes.

  ## Examples

      iex> change_skill(skill)
      %Ecto.Changeset{data: %Skill{}}

  """
  def change_skill(%Skill{} = skill, attrs \\ %{}) do
    Skill.changeset(skill, attrs)
  end

  @doc """
  Returns whether or not the ninja has a Skill

  ## Examples

      iex> ninja_has_skill?(123, 123)
      true

      iex> ninja_has_skill?(123, 456)
      false

  """
  def ninja_has_skill?(ninja_id, skill_id) do
    NinjaSkill
    |> where([ns], ns.ninja_id == ^ninja_id and ns.skill_id == ^skill_id)
    |> Repo.exists?()
  end

  @doc """
  Returns the list of skills of a ninja.
  ## Examples
      iex> list_ninja_skills(123)
      [%Skill{}, ...]
  """
  def list_ninja_skills(ninja_id) do
    NinjaSkill
    |> where([ns], ns.ninja_id == ^ninja_id)
    |> join(:inner, [ns], s in Skill, on: s.id == ns.skill_id)
    |> select([ns, s], s)
    |> Repo.all()
  end

  @doc """
  Returns the list of ninjas with a skill.
  ## Examples
      iex> list_ninjas_with_skill(123)
      [%Ninja{}, ...]
  """
  def list_ninjas_with_skill(skill_id) do
    NinjaSkill
    |> where([ns], ns.skill_id == ^skill_id)
    |> join(:inner, [ns], n in Ninja, on: n.id == ns.ninja_id)
    |> select([ns, n], n)
    |> Repo.all()
  end

  @doc """
  Creates a ninja skill.

  ## Examples

      iex> create_ninja_skill(%{field: value})
      {:ok, %NinjaSkill{}}

      iex> create_ninja_skill(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ninja_skill(attrs \\ %{}) do
    %NinjaSkill{}
    |> NinjaSkill.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a ninja skill.

  ## Examples

      iex> delete_ninja_skill(123, 123)
      {1, nil}
  """
  def delete_ninja_skill(ninja_id, skill_id) do
    NinjaSkill
    |> where([ns], ns.ninja_id == ^ninja_id and ns.skill_id == ^skill_id)
    |> Repo.delete_all()
  end

  @doc """
  Returns whether or not the Mentor has a Skill

  ## Examples

      iex> mentor_has_skill?(123, 123)
      true

      iex> mentor_has_skill?(123, 456)
      false

  """
  def mentor_has_skill?(mentor_id, skill_id) do
    MentorSkill
    |> where([ns], ns.mentor_id == ^mentor_id and ns.skill_id == ^skill_id)
    |> Repo.exists?()
  end

  @doc """
  Returns the list of skills of a mentor.
  ## Examples
      iex> list_mentor_skills(123)
      [%Skill{}, ...]
  """
  def list_mentor_skills(mentor_id) do
    MentorSkill
    |> where([ms], ms.mentor_id == ^mentor_id)
    |> join(:inner, [ms], s in Skill, on: s.id == ms.skill_id)
    |> select([ms, s], s)
    |> Repo.all()
  end

  @doc """
  Returns the list of mentors with a skill.
  ## Examples
      iex> list_mentor_with_skill(123)
      [%Mentor{}, ...]
  """
  def list_mentors_with_skill(skill_id) do
    MentorSkill
    |> where([ms], ms.skill_id == ^skill_id)
    |> join(:inner, [ms], m in Mentor, on: m.id == ms.mentor_id)
    |> select([ms, m], m)
    |> Repo.all()
  end

  @doc """
  Creates a mentor skill.

  ## Examples

      iex> create_mentor_skill(%{field: value})
      {:ok, %MentorSkill{}}

      iex> create_mentor_skill(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_mentor_skill(attrs \\ %{}) do
    %MentorSkill{}
    |> MentorSkill.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a mentor skill.

  ## Examples

      iex> delete_mentor_skill(123, 123)
      {1, nil}
  """
  def delete_mentor_skill(mentor_id, skill_id) do
    MentorSkill
    |> where([ms], ms.mentor_id == ^mentor_id and ms.skill_id == ^skill_id)
    |> Repo.delete_all()
  end
end
