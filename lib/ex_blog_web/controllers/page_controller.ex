defmodule ExBlogWeb.PageController do
  use ExBlogWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
