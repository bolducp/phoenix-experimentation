defmodule ChatWeb.AuthController do
  use ChatWeb, :controller
  plug Ueberauth

  alias Chat.Repo
  alias Chat.Accounts.User

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    user_params = %{github_token: auth.credentials.token, username: auth.info.nickname, name: auth.info.name,  provider: "github"}
    changeset = User.changeset(%User{}, user_params)

    sign_in(conn, changeset)
  end

  defp sign_in(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back")
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: "/chat")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: session_path(conn, :new))
    end
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, username: changeset.changes.username) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end
end
