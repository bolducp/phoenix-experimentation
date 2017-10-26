defmodule Chat.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chat.Accounts.{User, Credential}


  schema "users" do
    field :name, :string
    field :username, :string
    field :provider, :string
    field :github_token, :binary
    has_one :credential, Credential

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :username, :provider, :github_token])
    |> validate_required([:name, :username, :github_token])
    |> unique_constraint(:username)
  end
end
