defmodule Bokken.Factories.EventFactory do
   @moduledoc """
   A factory to generate event related structs
   """
   defmacro __using__(_opts) do
     quote do
       alias Bokken.Events.{
         Availability,
         Enrollment,
         Event,
         Lecture,
         LectureMentorAssistant,
         Location,
         Team,
         TeamMentor,
         TeamNinja
       }

       alias Faker.{Address, DateTime, Lorem, Pokemon}

       def availability_factory do
         %Availability{
           is_available: Enum.random([true, false]),
           mentor: build(:mentor),
           event: build(:event),
           notes: Lorem.sentence(0..10)
         }
       end

       def enrollment_factory do
         %Enrollment{
           event: build(:event),
           ninja: build(:ninja),
           accepted: Enum.random([true, false]),
           notes: Lorem.sentence(0..10)
         }
       end

       def event_factory do
         enrollments_open = DateTime.backward(10)
         enrollments_close = DateTime.forward(10)

         start_time = %{enrollments_close | hour: 9, minute: 30}

         end_time = %{start_time | hour: 12, minute: 30}

         %Event{
           title: Lorem.Shakespeare.hamlet(),
           spots_available: Enum.random(20..50),
           enrollments_open: enrollments_open,
           enrollments_close: enrollments_close,
           start_time: start_time,
           end_time: end_time,
           online: Enum.random([true, false]),
           notes: Lorem.sentence(0..10),
           location: build(:location),
           team: build(:team)
         }
       end

       def lecture_factory do
         %Lecture{
           notes: Lorem.sentence(0..10),
           summary: Lorem.sentence(10..50),
           attendance: Enum.random([:both_present, :both_absent, :ninja_absent, :mentor_absent]),
           mentor: build(:mentor),
           ninja: build(:ninja),
           event: build(:event)
         }
       end

       def lecture_mentor_assistant_factory do
         %LectureMentorAssistant{
           lecture: build(:lecture),
           mentor: build(:mentor)
         }
       end

       def location_factory do
         %Location{
           address: Address.PtBr.street_address(),
           name: Pokemon.En.name()
         }
       end

       def team_factory do
         %Team{
           name: Pokemon.name(),
           description: Lorem.sentence(0..20)
         }
       end

       def team_mentor_factory do
         %TeamMentor{
           mentor: build(:mentor),
           team: build(:team)
         }
       end

       def team_ninja_factory do
         %TeamNinja{
           ninja: build(:ninja),
           team: build(:team)
         }
       end
     end
   end
 end
