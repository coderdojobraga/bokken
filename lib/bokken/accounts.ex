defmodule Bokken.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Bokken.Repo

  alias Bokken.Events
  alias Bokken.Events.{Event, Lecture, TeamMentor, TeamNinja}

  alias Bokken.Gamification

  alias Bokken.Accounts.Guardian

  @doc """
  Returns the list of guardians.
  ## Examples
      iex> list_guardians()
      [%Guardian{}, ...]
  """
  def list_guardians do
    Repo.all(Guardian)
  end

  @doc """
  Gets a single guardian.
  Raises `Ecto.NoResultsError` if the Guardian does not exist.
  ## Examples
      iex> get_guardian!(123)
      %Guardian{}
      iex> get_guardian!(456)
      ** (Ecto.NoResultsError)
  """
  def get_guardian!(id, preloads \\ []) do
    Repo.get!(Guardian, id) |> Repo.preload(preloads)
  end

  @doc """
  Creates a guardian.
  ## Examples
      iex> create_guardian(%{field: value})
      {:ok, %Guardian{}}
      iex> create_guardian(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_guardian(attrs \\ %{}) do
    %Guardian{}
    |> Guardian.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a guardian.
  ## Examples
      iex> update_guardian(guardian, %{field: new_value})
      {:ok, %Guardian{}}
      iex> update_guardian(guardian, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def update_guardian(%Guardian{} = guardian, attrs) do
    guardian
    |> Guardian.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a guardian.
  ## Examples
      iex> delete_guardian(guardian)
      {:ok, %Guardian{}}
      iex> delete_guardian(guardian)
      {:error, %Ecto.Changeset{}}
  """
  def delete_guardian(%Guardian{} = guardian) do
    Repo.delete(guardian)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking guardian changes.
  ## Examples
      iex> change_guardian(guardian)
      %Ecto.Changeset{data: %Guardian{}}
  """
  def change_guardian(%Guardian{} = guardian, attrs \\ %{}) do
    Guardian.changeset(guardian, attrs)
  end

  alias Bokken.Accounts.Mentor

  @doc """
  Returns the list of mentors.

  ## Examples

      iex> list_mentors()
      [%Mentor{}, ...]

  """
  @spec list_mentors(map()) :: list(Mentor.t())
  def list_mentors(args \\ %{})

  def list_mentors(%{"team_id" => team_id}) do
    team_id
    |> Events.get_team!([:mentors])
    |> Map.fetch!(:mentors)
  end

  def list_mentors(%{"event_id" => event_id}) do
    event_id
    |> Events.get_event!([:mentors])
    |> Map.fetch!(:mentors)
  end

  def list_mentors(_args) do
    Mentor
    |> Repo.all()
  end

  @doc """
  Gets a single mentor.

  Raises `Ecto.NoResultsError` if the Mentor does not exist.

  ## Examples

      iex> get_mentor!(123)
      %Mentor{}

      iex> get_mentor!(456)
      ** (Ecto.NoResultsError)

  """
  def get_mentor!(id, preloads \\ []) do
    Repo.get!(Mentor, id) |> Repo.preload(preloads)
  end

  @doc """
  Creates a mentor.

  ## Examples

      iex> create_mentor(%{field: value})
      {:ok, %Mentor{}}

      iex> create_mentor(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_mentor(attrs \\ %{}) do
    %Mentor{}
    |> Mentor.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a mentor.

  ## Examples

      iex> update_mentor(mentor, %{field: new_value})
      {:ok, %Mentor{}}

      iex> update_mentor(mentor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_mentor(%Mentor{} = mentor, attrs) do
    mentor
    |> Mentor.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a mentor.

  ## Examples

      iex> delete_mentor(mentor)
      {:ok, %Mentor{}}

      iex> delete_mentor(mentor)
      {:error, %Ecto.Changeset{}}

  """
  def delete_mentor(%Mentor{} = mentor) do
    Repo.delete(mentor)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking mentor changes.

  ## Examples

      iex> change_mentor(mentor)
      %Ecto.Changeset{data: %Mentor{}}

  """
  def change_mentor(%Mentor{} = mentor, attrs \\ %{}) do
    Mentor.changeset(mentor, attrs)
  end

  def add_mentor_to_team(team_id, mentor_id) do
    %TeamMentor{}
    |> TeamMentor.changeset(%{team_id: team_id, mentor_id: mentor_id})
    |> Repo.insert()
  end

  def remove_mentor_team(team_id, mentor_id) do
    query =
      from team_mentor in TeamMentor,
        where: team_mentor.team_id == ^team_id,
        where: team_mentor.mentor_id == ^mentor_id

    Repo.delete_all(query)
  end

  alias Bokken.Accounts.Ninja

  @doc """
  Returns the list of ninjas.

  Takes a map with the following optional arguments:

    * `:badge_id` - A badge id to filter the results by.
    * `:team_id` - A badge id to filter the results by.

  ## Examples

      iex> list_ninjas()
      [%Ninja{}, ...]

  """

  @spec list_ninjas(map()) :: list(Ninja.t())
  def list_ninjas(args \\ %{})

  def list_ninjas(%{"team_id" => team_id}) do
    team_id
    |> Events.get_team!([:ninjas])
    |> Map.fetch!(:ninjas)
  end

  def list_ninjas(%{"badge_id" => badge_id}) do
    badge_id
    |> Gamification.get_badge!([:ninjas])
    |> Map.fetch!(:ninjas)
  end

  def list_ninjas(%{"event_id" => event_id}) do
    event_id
    |> Events.get_event!([:ninjas])
    |> Map.fetch!(:ninjas)
  end

  def list_ninjas(_args) do
    Ninja
    |> Repo.all()
  end

  @doc """
  Gets a single ninja.

  Raises `Ecto.NoResultsError` if the Ninja does not exist.

  ## Examples

      iex> get_ninja!(123)
      %Ninja{}

      iex> get_ninja!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ninja!(id, preloads \\ []) do
    Repo.get!(Ninja, id) |> Repo.preload(preloads)
  end

  @doc """
  Creates a ninja.

  ## Examples

      iex> create_ninja(%{field: value})
      {:ok, %Ninja{}}

      iex> create_ninja(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ninja(attrs \\ %{}) do
    %Ninja{}
    |> Ninja.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ninja.

  ## Examples

      iex> update_ninja(ninja, %{field: new_value})
      {:ok, %Ninja{}}

      iex> update_ninja(ninja, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ninja(%Ninja{} = ninja, attrs) do
    ninja
    |> Ninja.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ninja.

  ## Examples

      iex> delete_ninja(ninja)
      {:ok, %Ninja{}}

      iex> delete_ninja(ninja)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ninja(%Ninja{} = ninja) do
    Repo.delete(ninja)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ninja changes.

  ## Examples

      iex> change_ninja(ninja)
      %Ecto.Changeset{data: %Ninja{}}

  """
  def change_ninja(%Ninja{} = ninja, attrs \\ %{}) do
    Ninja.changeset(ninja, attrs)
  end

  def add_ninja_to_team(ninja_id, team_id) do
    %TeamNinja{}
    |> TeamNinja.changeset(%{ninja_id: ninja_id, team_id: team_id})
    |> Repo.insert()
  end

  def remove_ninja_team(team_id, ninja_id) do
    query =
      from team_ninja in TeamNinja,
        where: team_ninja.team_id == ^team_id,
        where: team_ninja.ninja_id == ^ninja_id

    Repo.delete_all(query)
  end

  def register_ninja_in_event(event_id, ninja_id) do
    event = Events.get_event!(event_id)

    transaction =
      Ecto.Multi.new()
      |> Ecto.Multi.update(
        :event,
        Event.changeset(event, %{spots_available: event.spots_available - 1})
      )
      |> Ecto.Multi.insert(
        :lecture,
        Lecture.changeset(%Lecture{}, %{event_id: event_id, ninja_id: ninja_id})
      )
      |> Repo.transaction()

    case transaction do
      {:ok, %{event: event, lecture: lecture}} ->
        {:ok, event |> Repo.preload([:ninjas], force: true), lecture}

      {:error, _transation, errors, _changes_so_far} ->
        {:error, errors}
    end
  end

  alias Bokken.Accounts.Organizer

  @doc """
  Returns the list of organizers.

  ## Examples

      iex> list_organizers()
      [%Organizer{}, ...]

  """
  def list_organizers do
    Repo.all(Organizer)
  end

  @doc """
  Gets a single organizer.

  Raises `Ecto.NoResultsError` if the Organizer does not exist.

  ## Examples

      iex> get_organizer!(123)
      %Organizer{}

      iex> get_organizer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_organizer!(id, preloads \\ []) do
    Repo.get!(Organizer, id) |> Repo.preload(preloads)
  end

  @doc """
  Creates a organizer.

  ## Examples

      iex> create_organizer(%{field: value})
      {:ok, %Organizer{}}

      iex> create_organizer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_organizer(attrs \\ %{}) do
    %Organizer{}
    |> Organizer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a organizer.

  ## Examples

      iex> update_organizer(organizer, %{field: new_value})
      {:ok, %Organizer{}}

      iex> update_organizer(organizer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_organizer(%Organizer{} = organizer, attrs) do
    organizer
    |> Organizer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a organizer.

  ## Examples

      iex> delete_organizer(organizer)
      {:ok, %Organizer{}}

      iex> delete_organizer(organizer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_organizer(%Organizer{} = organizer) do
    Repo.delete(organizer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking organizer changes.

  ## Examples

      iex> change_organizer(organizer)
      %Ecto.Changeset{data: %Organizer{}}

  """
  def change_organizer(%Organizer{} = organizer, attrs \\ %{}) do
    Organizer.changeset(organizer, attrs)
  end

  alias Bokken.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  def get_user(attrs) when is_list(attrs) do
    Repo.get_by(User, attrs)
  end

  def get_user(id), do: Repo.get(User, id)

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id, preloads \\ []) do
    Repo.get!(User, id) |> Repo.preload(preloads)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def sign_up_user(attrs \\ %{}) do
    %User{}
    |> User.register_changeset(attrs)
    |> Repo.insert()
  end

  def register_user(%User{} = user, attrs \\ %{}) do
    result =
      Ecto.Multi.new()
      |> Ecto.Multi.update(:user, User.changeset(user, %{registered: true}))
      |> Ecto.Multi.insert(user.role, &create_role_changeset(&1, normalize_map_keys(attrs)))
      |> Repo.transaction()

    case result do
      {:ok, %{user: user}} ->
        {:ok, user |> Repo.preload(user.role, force: true)}

      {:error, _transation, errors, _changes_so_far} ->
        {:error, errors}
    end
  end

  defp create_role_changeset(%{user: user}, attrs) do
    attrs = Map.put(attrs, "user_id", user.id)

    case user.role do
      :mentor ->
        Mentor.changeset(%Mentor{}, attrs)

      :guardian ->
        Guardian.changeset(%Guardian{}, attrs)

      :organizer ->
        Organizer.changeset(%Organizer{}, attrs)
    end
  end

  defp normalize_map_keys(map) do
    for {key, val} <- map, into: %{} do
      {to_string(key), val}
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def edit_user(%User{} = user, attrs, role) do
    result =
      Ecto.Multi.new()
      |> Ecto.Multi.update(:user, User.edit_changeset(user, attrs))
      |> Ecto.Multi.update(role, &update_role_changeset(&1, attrs))
      |> Repo.transaction()

    case result do
      {:ok, %{user: user}} ->
        {:ok, user |> Repo.preload(role, force: true)}

      {:error, _transation, errors, _changes_so_far} ->
        {:error, errors}
    end
  end

  defp update_role_changeset(%{user: user}, attrs) do
    case user.role do
      :mentor ->
        Mentor.changeset(user.mentor, attrs)

      :guardian ->
        Guardian.changeset(user.guardian, attrs)

      :ninja ->
        Ninja.changeset(user.ninja, attrs)
    end
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc false
  def authenticate_user(email, password) do
    get_user(email: email)
    |> authenticate_resource(password)
  end

  defp authenticate_resource(nil, _password) do
    Argon2.no_user_verify()
    {:error, :not_registered}
  end

  defp authenticate_resource(user, password) do
    if Argon2.verify_pass(password, user.password_hash) do
      {:ok, user |> then(&Repo.preload(&1, [&1.role]))}
    else
      {:error, :invalid_credentials}
    end
  end

  @doc """
  Verifies a user email

  ## Examples

      iex> verify_user_email(user_email)
      {:ok, %User{}}

  """
  def verify_user_email(email) do
    user =
      get_user(email: email)
      |> Repo.preload([:guardian, :organizer, :mentor, :ninja])

    if is_nil(user) do
      {:error, :not_found}
    else
      update_user(user, %{verified: true})
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def create_reset_password_token(user) do
    token = random_string(48)
    sent_at = DateTime.utc_now()

    user
    |> User.password_token_changeset(%{reset_password_token: token, reset_token_sent_at: sent_at})
    |> Repo.update!()
  end

  def get_user_by_email(email) do
    User
    |> Repo.get_by(email: email)
  end

  def get_user_by_token(token) do
    User
    |> Repo.get_by(reset_password_token: token)
  end

  defp random_string(len) do
    :crypto.strong_rand_bytes(len)
    |> Base.url_encode64()
    |> binary_part(0, len)
  end

  def update_reset_password_token(%User{} = user, attrs \\ %{}) do
    User.password_token_changeset(user, attrs)
    |> Repo.update!()
  end

  def token_expired?(sent_at) do
    diff = DateTime.diff(DateTime.utc_now(), sent_at)

    # Checks if one day passed since the token was sent
    diff / 60 / 60 / 24 > 1
  end

  alias Ecto.Multi

  def reset_user_password(user, params, attrs \\ %{}) do
    Multi.new()
    |> Multi.update(:user, User.update_password_changeset(user, params))
    |> Multi.update(:after_password, User.password_token_changeset(user, attrs))
    |> Repo.transaction()
  end
end
