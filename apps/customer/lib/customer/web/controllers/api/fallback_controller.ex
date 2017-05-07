defmodule Customer.Web.Api.FallbackController do
  use Customer.Web, :controller
  alias Customer.Web.Api.ErrorView

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    errorMessage = Error.message(changeset)
    conn
    |> put_status(:unprocessable_entity)
    |> render(ErrorView, "unprocessable_entity.json", %{errorMessage: errorMessage})
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(ErrorView, "not_found.json")
  end

  def call(conn, {:error, :unauthorized}, _format) do
     conn
     |> put_status(:unauthorized)
     |> render(ErrorView, "unauthorized.json")
  end

  def call(conn, {:error, reason}) do
    IO.inspect reason
  end
end