defmodule ExBlogWeb.SessionController do
  use ExBlogWeb, :controller

  alias ExBlog.Accounts
  alias ExBlog.Accounts.User
  alias ExBlog.Accounts.Guardian

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    Accounts.authenticate_user(email, password)
    |> login_reply(conn)
  end

  defp login_reply({:error, error}, conn) do
    conn
    |> put_flash(:error, error)
    |> redirect(to: session_path(conn, :new))
  end
  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:success, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/")
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, "Logout successfully.")
    |> redirect(to: page_path(conn, :index))
  end
end
