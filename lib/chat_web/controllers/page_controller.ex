defmodule ChatWeb.PageController do
  use ChatWeb, :controller

  def index(conn, _params) do
    render conn, :index
  end

  def test(conn, _params) do
    render conn, "test.html"
  end
end
