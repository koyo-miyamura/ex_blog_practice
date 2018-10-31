defmodule ExBlog.Support.Utils do
  alias ExBlog.Accounts.User
  alias ExBlog.Accounts.Guardian

  def login_user(conn, %User{} = user) do
    Guardian.Plug.sign_in(conn, user)
  end

  def logout_user(conn, %User{} = user) do
    Guardian.Plug.sign_out(conn, user)
  end
end
