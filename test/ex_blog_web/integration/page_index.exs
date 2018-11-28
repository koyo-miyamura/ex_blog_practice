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
    test "without login", %{conn: conn} do
      conn = get conn, "/"

      # html_responce is \ escaped like \"hogehoge\", not "hogehoge"
      # so we need \ before "
      assert html_response(conn, 200) =~ "Simple blog by Phoenix"
      assert html_response(conn, 200) =~ "href=\"#{user_path(conn, :new)}\""
    end
    test "logged in", %{conn: conn, user: user} do
      conn =
        conn
        |> login_user(user)
        |> get("/")
      assert get_flash(conn)
      refute html_response(conn, 200) =~ "href=\"#{user_path(conn, :new)}\""
    end
  end

end
