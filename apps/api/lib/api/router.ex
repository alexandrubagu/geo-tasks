defmodule API.Router do
  use API, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug API.Plugs.EnsureAuthenticated
  end

  scope "/api", API do
    pipe_through :api

    resources "/tasks", TaskController, only: [:index, :create, :delete] do
      post "/mark_as_done", TaskController, :mark_as_done
      post "/assign", TaskController, :assign
    end
  end
end
