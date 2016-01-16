defmodule Meli.MailWorker do
  require Logger

  def perform(mail_params) do
    Logger.info "Sending an email, #{inspect mail_params}"
    Logger.info "Delivered #{inspect mail_params}"
  end
end
