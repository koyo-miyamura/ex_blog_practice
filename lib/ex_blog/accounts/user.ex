defmodule ExBlog.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExBlog.Blog.Article

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string

    has_many :articles, Article
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> unique_constraint(:email)
  end
end
