defmodule ExBlogWeb.LayoutTest do
  use ExBlogWeb.ConnCase
  import ExBlog.Support.Utils
  alias ExBlog.Accounts

  @valid_attrs %{email: "some@example.com", name: "somename", password: "somepassword"}

  setup do
    {:ok, user} = Accounts.create_user(@valid_attrs)
    {:ok, user: user}
  end

  describe "get /" do
    test "without login", %{conn: conn, user: user} do
      conn = get conn, "/"

      # html_responce is \ escaped like \"hogehoge\", not "hogehoge"
      # so we need \ before "
      assert html_response(conn, 200) =~ "Simple blog by Phoenix"
      assert html_response(conn, 200) =~ "href=\"#{user_path(conn, :new)}\""
      assert html_response(conn, 200) =~ "href=\"#{page_path(conn, :index)}\""
      assert html_response(conn, 200) =~ "href=\"#{session_path(conn, :new)}\""

      refute html_response(conn, 200) =~ "href=\"#{article_path(conn, :index)}\""
      refute html_response(conn, 200) =~ "href=\"#{user_path(conn, :index)}\""
      refute html_response(conn, 200) =~ "href=\"#{user_path(conn, :show, user)}\""
      refute html_response(conn, 200) =~ "href=\"#{session_path(conn, :delete)}\""
    end
    test "logged in", %{conn: conn, user: user} do
      conn =
        conn
        |> login_user(user)
        |> get("/")
      assert get_flash(conn)
      refute html_response(conn, 200) =~ "href=\"#{user_path(conn, :new)}\""
      refute html_response(conn, 200) =~ "href=\"#{session_path(conn, :new)}\""

      assert html_response(conn, 200) =~ "href=\"#{article_path(conn, :index)}\""
      assert html_response(conn, 200) =~ "href=\"#{user_path(conn, :index)}\""
      assert html_response(conn, 200) =~ "href=\"#{user_path(conn, :show, user)}\""
      assert html_response(conn, 200) =~ "href=\"#{session_path(conn, :delete)}\""
    end
  end

end
