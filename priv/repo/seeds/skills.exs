defmodule Bokken.Repo.Seeds.Skills do
  require Logger
  def run do
    case Bokken.Repo.all(Bokken.Accounts.Skill) do
      [] ->
        [
          %{
            name: "Python",
            description: "Python is a high-level, interpreted, general-purpose programming language. Its design philosophy emphasizes code readability with the use of significant indentation."
          },
          %{
            name: "Scratch",
            description: "Scratch is a high-level block-based visual programming language and website aimed primarily at children as an educational tool for programming, with a target audience of ages 8 to 16."
          },
          %{
            name: "C#",
            description: "C# is a general-purpose, multi-paradigm programming language."
          },
          %{
            name: "HTML/CSS/Javascript",
            description: "JavaScript often abbreviated JS, is a programming language that is one of the core technologies of the World Wide Web"
          },
          %{
            name: "Elixir",
            description: "Elixir is a functional, concurrent, general-purpose programming language that runs on the BEAM virtual machine which is also used to implement the Erlang programming language."
          }
        ]
        |> create_skills()

      _ ->
        Mix.shell().error("Found skills, aborting seeding skills.")
    end

    case Bokken.Repo.all(Bokken.Accounts.NinjaSkill) do
      [] ->
        create_ninja_skills(Bokken.Repo.all(Bokken.Accounts.Skill),
          Bokken.Repo.all(Bokken.Accounts.Ninja))

      _ ->
        Mix.shell().error("Found ninja skills, aborting seeding ninja skills.")
    end

    case Bokken.Repo.all(Bokken.Accounts.MentorSkill) do
      [] ->
        create_mentor_skills(Bokken.Repo.all(Bokken.Accounts.Skill),
          Bokken.Repo.all(Bokken.Accounts.Mentor))

      _ ->
        Mix.shell().error("Found mentor skills, aborting seeding mentor skills.")
    end
  end

  def create_skills(skills) do
    for skill <- skills do

      case Bokken.Accounts.create_skill(skill) do
        {:error, changeset} ->
          Mix.shell().error(Kernel.inspect(changeset.errors))

        {:ok, %{id: user_id}} -> user_id
      end
    end
  end

  defp create_ninja_skills(skills, ninjas) do
    n = 6

    for ninja <- ninjas do
      for skill <- Enum.take_random(skills , Enum.random(1..n)) do
        %{
          skill_id: skill.id,
          ninja_id: ninja.id
        }
        |> Bokken.Accounts.create_ninja_skill()
      end
    end
  end

  defp create_mentor_skills(skills, mentors) do
    n = 6
    for mentor <- mentors do
      for skill <- Enum.take_random(skills , Enum.random(1..n)) do
        %{
          skill_id: skill.id,
          mentor_id: mentor.id
        }
        |> Bokken.Accounts.create_mentor_skill()
      end
    end
  end
end

Bokken.Repo.Seeds.Skills.run
