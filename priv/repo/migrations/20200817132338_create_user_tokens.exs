defmodule PoolWatch.Repo.Migrations.CreateUserTokens do
  use Ecto.Migration

  def change do
    create table(:user_tokens, primary_key: false) do
      add :id, :binary_id, default: fragment("uuid_generate_v4()"), primary_key: true
      add :token, :string, null: false
      add :type, :string, null: false, default: "AUTH"
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create unique_index(:user_tokens, [:token])
    create index(:user_tokens, [:user_id])
  end
end
