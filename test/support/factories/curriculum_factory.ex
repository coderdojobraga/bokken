defmodule Bokken.Factories.CurriculumFactory do
   @moduledoc """
   A factory to generate curriculum related structs
   """
   defmacro __using__(_opts) do
     quote do
       alias Bokken.Curriculum.{MentorSkill, NinjaSkill, Skill}
       alias Bokken.Factories.AccountFactory
       alias Faker.{Lorem, Pokemon}

       def skill_factory do
         %Skill{
           name: Pokemon.name(),
           description: Lorem.sentence()
         }
       end

       def mentor_skill_factory do
         %MentorSkill{
           skill: build(:skill),
           mentor: build(:mentor)
         }
       end

       def ninja_skill_factory do
         %NinjaSkill{
           skill: build(:skill),
           ninja: build(:ninja)
         }
       end
     end
   end
 end
