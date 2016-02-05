defmodule Meli.MailController do
  use Meli.Web, :controller

  plug :scrub_params, "mails"

  def create(conn, params) do
    resp = params
      |> Meli.RequestParser.parse
      |> enqueue_mails

    conn |> put_status(:created) |> json(resp)
  end

  defp enqueue_mails(mails) do
    Enum.reduce mails, %{queued: [], failed: []}, fn mail, result ->
      IO.inspect mail
      case Exq.enqueue(Exq, "default", Meli.MailWorker, [mail]) do
        {:ok, _}    -> Map.update! result, :queued, &[mail | &1]
        {:error, _} -> Map.update! result, :failed, &[mail | &1]
      end
    end
  end
end
