defmodule LoginWeb.PageController do
  use LoginWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
