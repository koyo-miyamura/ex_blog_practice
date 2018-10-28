defmodule ExBlogWeb.ArticleController do
  use ExBlogWeb, :controller

  alias ExBlog.Blog
  alias ExBlog.Blog.Article
  alias ExBlog.Accounts
  alias ExBlog.Accounts.Guardian

  plug :is_authorized when action in [:edit, :update, :delete]

  def index(conn, _params) do
    articles = Blog.list_articles()
    render(conn, "index.html", articles: articles)
  end

  def new(conn, _params) do
    changeset = Blog.change_article(%Article{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"article" => article_params}) do
    case Blog.create_article(Guardian.Plug.current_resource(conn), article_params) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article created successfully.")
        |> redirect(to: article_path(conn, :show, article))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    article = Blog.get_article!(id)
    render(conn, "show.html", article: article)
  end

  def edit(conn, _) do
    article = conn.assigns.article
    changeset = Blog.change_article(article)
    render(conn, "edit.html", article: article, changeset: changeset)
  end

  def update(conn, %{"article" => article_params}) do
    article = conn.assigns.article

    case Blog.update_article(article, article_params) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article updated successfully.")
        |> redirect(to: article_path(conn, :show, article))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", article: article, changeset: changeset)
    end
  end

  def delete(conn, _) do
    article = conn.assigns.article
    {:ok, _article} = Blog.delete_article(article)

    conn
    |> put_flash(:info, "Article deleted successfully.")
    |> redirect(to: article_path(conn, :index))
  end

  # Current_user can access only own resources
  # Check current_user's id match article.user.id
  defp is_authorized(conn, _) do
    current_user = Accounts.current_user(conn)
    article = Blog.get_article!(conn.params["id"])
    if current_user.id == article.user.id do
      assign(conn, :article, article)
    else
      conn
      |> put_flash(:error, "You can't modify that page")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
