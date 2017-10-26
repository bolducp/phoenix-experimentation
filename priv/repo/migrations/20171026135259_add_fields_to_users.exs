defmodule Chat.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :provider, :string
      add :github_token, :string
    end
  end
end
