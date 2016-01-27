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
    config = Application.get_env(:meli, :smtp)

    %Mailman.SmtpConfig{
      relay:    config[:relay],
      username: config[:username],
      password: config[:password],
      port:     config[:port],
      ssl:      config[:ssl],
      auth:     config[:auth],
      tls:      config[:tls]
    }
  end
end
