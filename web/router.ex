defmodule Meli.Router do
  use Meli.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
    plug ExqUi.RouterPlug, namespace: "exq"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Meli do
    pipe_through :browser

    forward "/exq", ExqUi.RouterPlug.Router, :index
  end

  scope "/api", Meli do
    pipe_through :api

    post "/mail", MailController, :create
  end
end
