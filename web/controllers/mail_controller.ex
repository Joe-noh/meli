defmodule Meli.MailController do
  use Meli.Web, :controller

  plug :scrub_params, "mail"

  def create(conn, %{"mail" => mail_params}) do
    case Exq.enqueue(Exq, "default", Meli.MailWorker, [mail_params]) do
      {:ok, ack}    -> render_ok(conn, mail_params)
      {:error, why} -> render_error(conn, why)
    end
  end

  defp render_ok(conn, mail_params) do
    conn
    |> put_status(:created)
    |> json(%{"mail" => mail_params})
  end

  defp render_error(conn, why) do
    conn
    |> put_status(500)
    |> json(%{error: why})
  end
end
