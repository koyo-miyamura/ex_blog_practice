defmodule ExBlogWeb.ArticleControllerTest do
  use ExBlogWeb.ConnCase

  import ExBlog.Support.Utils

  alias ExBlog.Blog
  alias ExBlog.Accounts
  alias ExBlog.Accounts.User

  @valid_user_attrs %{email: "some@example.com", name: "somename", password: "somepassword"}

  @create_attrs %{content: "some content", title: "some title"}
  @update_attrs %{content: "some updated content", title: "some updated title"}
  @invalid_attrs %{content: nil, title: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@valid_user_attrs)
    user
  end

  def fixture(:article, %User{} = user) do
    {:ok, article} = Blog.create_article(user, @create_attrs)
    article
  end

  describe "need login" do
    setup [:create_article]

    test "index", %{conn: conn} do
      conn = get conn, article_path(conn, :index)
      assert response(conn, 401)
    end
    test "new", %{conn: conn} do
      conn = get conn, article_path(conn, :new)
      assert response(conn, 401)
    end
    test "create", %{conn: conn} do
      conn = get conn, article_path(conn, :create)
      assert response(conn, 401)
    end
    test "show", %{conn: conn, article: article} do
      conn = get conn, article_path(conn, :show, article)
      assert response(conn, 401)
    end
    test "edit", %{conn: conn, article: article} do
      conn = get conn, article_path(conn, :edit, article)
      assert response(conn, 401)
    end
    test "update", %{conn: conn, article: article} do
      conn = get conn, article_path(conn, :update, article)
      assert response(conn, 401)
    end
    test "delete", %{conn: conn, article: article} do
      conn = get conn, article_path(conn, :delete, article)
      assert response(conn, 401)
    end
  end

  describe "index" do
    setup [:create_user]

    test "lists all articles", %{conn: conn, user: user} do
      conn = login_user(conn, user)
      conn = get conn, article_path(conn, :index)
      assert response(conn, 200)
    end
  end

## 以下まだ書いていないのでデフォルトのまま

  describe "new article" do
    test "renders form", %{conn: conn} do
      conn = get conn, article_path(conn, :new)
      assert html_response(conn, 200) =~ "New Article"
    end
  end

  describe "create article" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, article_path(conn, :create), article: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == article_path(conn, :show, id)

      conn = get conn, article_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Article"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, article_path(conn, :create), article: @invalid_attrs
      assert html_response(conn, 200) =~ "New Article"
    end
  end

  describe "edit article" do
    setup [:create_article]

    test "renders form for editing chosen article", %{conn: conn, article: article} do
      conn = get conn, article_path(conn, :edit, article)
      assert html_response(conn, 200) =~ "Edit Article"
    end
  end

  describe "update article" do
    setup [:create_article]

    test "redirects when data is valid", %{conn: conn, article: article} do
      conn = put conn, article_path(conn, :update, article), article: @update_attrs
      assert redirected_to(conn) == article_path(conn, :show, article)

      conn = get conn, article_path(conn, :show, article)
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, article: article} do
      conn = put conn, article_path(conn, :update, article), article: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Article"
    end
  end

  describe "delete article" do
    setup [:create_article]

    test "deletes chosen article", %{conn: conn, article: article} do
      conn = delete conn, article_path(conn, :delete, article)
      assert redirected_to(conn) == article_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, article_path(conn, :show, article)
      end
    end
  end

  defp create_article(_) do
    user = fixture(:user)
    article = fixture(:article, user)
    {:ok, article: article}
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end

end
