defmodule Meli.RequestPerserTest do
  use ExUnit.Case

  test "correctly parses the parameters and evaluates EEx" do
    input = %{
      "common" => %{
        "from_address" => "sender@example.com",
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
          "from_address" => "override@example.com",
          "to_addresses" => ["recipient@example.com"],
          "data" => %{
            "name" => "田中",
            "points" => 3000
          }
        },
        %{
          "to_addresses" => ["rec1@example.com", "rec2@example.com"],
          "data" => %{
            "name" => "スズキ",
            "points" => 234
          }
        }
      ]
    }

    expected = [
      %Meli.Mail{
        to_addresses:  ["recipient@example.com"],
        to_names:      [],
        from_address:  "override@example.com",
        from_name:     "",
        cc_addresses:  [],
        cc_names:      [],
        bcc_addresses: [],
        bcc_names:     [],
        subject:       "ようこそ 田中 様",
        text: """
        田中 様

        この度はご登録ありがとうございます。

        獲得ポイントは 3000pt です。
        """,
        html: """
        <p>田中 様</p>

        <p>
        この度はご登録ありがとうございます。

        獲得ポイントは <em>3000</em>pt です。
        </p>
        """
      },
      %Meli.Mail{
        to_addresses:  ["rec1@example.com", "rec2@example.com"],
        to_names:      [],
        from_address:  "sender@example.com",
        from_name:     "",
        cc_addresses:  [],
        cc_names:      [],
        bcc_addresses: [],
        bcc_names:     [],
        subject:       "ようこそ スズキ 様",
        text:          """
        スズキ 様

        この度はご登録ありがとうございます。

        獲得ポイントは 234pt です。
        """,
        html: """
        <p>スズキ 様</p>

        <p>
        この度はご登録ありがとうございます。

        獲得ポイントは <em>234</em>pt です。
        </p>
        """
      }]

    assert Meli.RequestParser.parse(input) == expected
  end
end
