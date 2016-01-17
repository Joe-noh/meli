defmodule Meli.MailWorker do
  require Logger

  def perform(mail_params) do
    {:ok, response} = mail_params
      |> build_mail
      |> Mailman.deliver(config)

    Logger.info response
  end

  defp build_mail(mail) do
    %Mailman.Email{
      subject: Map.get(mail, "subject", ""),
      from: Map.get(mail, "from"),
      to:   Map.get(mail, "to", []),
      cc:   Map.get(mail, "cc", []),
      bcc:  Map.get(mail, "bcc", []),
      text: Map.get(mail, "text", ""),
      html: Map.get(mail, "html", "")
    }
  end

  defp config do
    %Mailman.Context{
      config:   smtp_config,
      composer: %Mailman.EexComposeConfig{}
    }
  end

  defp smtp_config do
    case Mix.env do
      :prod  -> smtp_prod_config
      _other -> smtp_test_config
    end
  end

  defp smtp_prod_config do
    %Mailman.SmtpConfig{
      relay: "smtp.gmail.com",
      username: Application.get_env(:meli, :smtp_username),
      password: Application.get_env(:meli, :smtp_password),
      port: 465,
      ssl: true,
      auth: :always
    }
  end

  defp smtp_test_config do
    %Mailman.TestConfig{store_deliveries: true}
  end
end
