defmodule ExBlogWeb.UserView do
  use ExBlogWeb, :view
  alias ExBlog.Accounts
  def current_user(conn) do
    Accounts.current_user(conn)
  end
end
