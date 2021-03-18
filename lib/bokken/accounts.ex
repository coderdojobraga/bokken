defmodule Bokken.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Bokken.Repo

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
  def get_user!(id), do: Repo.get!(User, id)

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
      {:ok, user}
    else
      {:error, :invalid_credentials}
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

  alias Bokken.Accounts.Mentor

  @doc """
  Returns the list of mentors.

  ## Examples

      iex> list_mentors()
      [%Mentor{}, ...]

  """
  def list_mentors do
    Repo.all(Mentor)
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
  def get_mentor!(id), do: Repo.get!(Mentor, id)

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
  def get_guardian!(id), do: Repo.get!(Guardian, id)

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
end
