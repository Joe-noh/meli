defmodule Meli.MailControllerTest do
  use Meli.ConnCase

  setup do
    on_exit fn -> Exq.Api.remove_queue(Exq.Enqueuer, "default") end
  end

  test "POST #create returns 201" do
    mail = %{subject: "Hey!"}

    conn
    |> post(mail_path(conn, :create), %{mail: mail})
    |> json_response(201)
  end
end
