defmodule ExBlog.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExBlog.Blog.Article
  alias Comeonin.Bcrypt

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
    |> validate_format(:email, ~r/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
    |> validate_length(:password, min: 5)
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hashpwsalt(password))
  end
  defp put_pass_hash(changeset), do: changeset
end
