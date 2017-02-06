defmodule Backlash.User do
  @moduledoc """
  * Entity that stores Users.

  ## Usage
      iex> Backlash.User.changeset(%Backlash.User, %{username: "A nice user"})
      nil

  ## Attributes
      * username: :string

  """

  use Backlash.Web, :model

  alias Backlash.User
  alias Backlash.Project
  alias Backlash.Repo
  alias Backlash.Reputation

  @typedoc """
  User struct

  ## Attributes
      * username
  """
  @type t :: %Backlash.User{}

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :admin, :boolean

    has_many :created_projects, Project
    has_many :reputed_projects, Reputation

    timestamps()
  end

  @doc """
  User changeset function.
  ## How it works
  If the given struct has an id, it means that the action is an update. So we use an `edit` changeset. Otherwise, we use an `new` changeset.
  ## Usage
      iex> Backlash.User.changeset(%Backlash.User, opts)
      %User{...}
      iex> # ^ new_changeset used
      iex> user = Repo.get(User, user.id)
      iex> Backlash.User.changeset(user, new_opts)
      %User{...}
      iex> # ^ edit_changeset used

  """

  @spec changeset(t, map) :: t
  def changeset(struct, params \\ %{}) do
    if struct.id do
      edit_changeset(struct, params)
    else
      new_changeset(struct, params)
    end
  end

  def edit_changeset(struct, params) do
    struct
    |> cast(params, [:username, :email])
    |> validate_length(:username, min: 5, max: 40)
    |> validate_length(:email, min: 4, max: 200)
  end

  def new_changeset(struct, params) do
    struct
    |> cast(params, [:username, :email, :password, :password_confirmation])
    |> validate_required([:email, :username])
    |> validate_length(:username, min: 5, max: 40)
    |> validate_length(:email, min: 4, max: 200)
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_length(:password, min: 6, max: 100)
    |> validate_required([:password])
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

  def promote_to_admin(user) do
    changeset = User.changeset(user, %{}) |> put_change(:admin, true)
    Repo.update(changeset)
  end

  def promote_to_admin!(user) do
    changeset = User.changeset(user, %{}) |> put_change(:admin, true)
    Repo.update!(changeset)
  end

  @spec total_projects_created(integer) :: integer
  def total_projects_created(user_id) do
    q = from p in Project, where: p.author_id==^user_id, select: count(p.id)
    Repo.one q
  end

  @spec repute_project(number, number) :: tuple
  def repute_project(user_id, project_id) do
    Reputation.changeset(%Reputation{}, %{user_id: user_id, project_id: project_id})
    |> Repo.insert
  end

  # obs: Im assuming that the user exist.
  @spec can_repute?(number, number) :: boolean
  def can_repute?(user_id, project_id) do
    if reputed?(user_id, project_id) do
      false
    else
      true
    end
  end

  @spec reputed?(number, number) :: boolean
  def reputed?(user_id, project_id) do
    q = from p in Reputation, where: p.user_id==^user_id and p.project_id==^project_id, select: count(p.id)
    case Repo.one(q) do
      1 ->
        true
      0 ->
        false
      _ ->
        false
    end
  end

  @spec unrepute_project(number, number) :: tuple
  def unrepute_project(user_id, project_id) do
    q = from p in Reputation, where: p.user_id==^user_id and p.project_id==^project_id
    {result, _} = Repo.delete_all q
    if result>0 do
      {:ok, result}
    else
      {:error, "Can't unrepute."}
    end
  end

end
