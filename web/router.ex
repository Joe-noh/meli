defmodule Meli.Router do
  use Meli.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Meli do
    pipe_through :api

    post "/mail", MailController, :create
  end
end
