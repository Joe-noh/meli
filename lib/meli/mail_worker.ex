defmodule Meli.MailWorker do
  require Logger

  def perform(mail = %Meli.Mail{}) do
    mail |> do_perform
  end

  def perform(mail = %{}) do
    mail |> Meli.Mail.new |> do_perform
  end

  defp do_perform(mail) do
    {:ok, response} = mail
      |> Meli.Mail.to_mailman_email
      |> Mailman.deliver(config)

    Logger.info inspect(:mimemail.decode(response))
  end

  defmodule DoNothing do
    defstruct []
  end

  defimpl Mailman.Composer, for: DoNothing do
    def compile_part(_config, :html, email), do: email.html
    def compile_part(_config, :text, email), do: email.text
    def compile_part(_config, :attachment, _), do: ""
  end

  defp config do
    %Mailman.Context{
      config:   smtp_config,
      composer: %DoNothing{}
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
