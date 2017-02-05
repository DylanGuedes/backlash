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

    timestamps()
  end

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
end
