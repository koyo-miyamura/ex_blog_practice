defmodule ExBlogWeb.LayoutView do
  use ExBlogWeb, :view
  alias ExBlog.Accounts.Guardian
  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end
end
