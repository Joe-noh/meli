defmodule Meli.MailControllerTest do
  use Meli.ConnCase

  setup do
    on_exit fn -> Exq.Api.remove_queue(Exq.Enqueuer, "default") end
  end

  test "POST #create returns 201" do
    params = %{
      "common" => %{
        "from_address" => "sender@example.com",
        "from_name" => "送信者",
        "subject" => "ようこそ <%= data[\"name\"] %> 様",
        "text" => """
        <%= data["name"] %> 様

        この度はご登録ありがとうございます。

        獲得ポイントは <%= data["points"] %>pt です。
        """,
        "html" => """
        <p><%= data["name"] %> 様</p>

        <p>
        この度はご登録ありがとうございます。

        獲得ポイントは <em><%= data["points"] %></em>pt です。
        </p>
        """
      },
      "mails" => [
        %{
          "to_addresses" => ["recipient@example.com"],
          "to_names" => ["受信者さん"],
          "data" => %{
            "name" => "田中",
            "points" => 3000
          }
        },
        %{
          "to_addresses" => ["rec1@example.com", "rec2@example.com"],
          "to_names" => ["受信者さん1", "受信者さん2"],
          "data" => %{
            "name" => "スズキ",
            "points" => 234
          }
        }
      ]
    }

    json = conn
      |> post(mail_path(conn, :create), params)
      |> json_response(201)

    assert json["queued"] |> is_list
    assert json["queued"] |> length == 2
    assert json["failed"] |> is_list

    :timer.sleep 1000
  end
end
