defmodule PlantCareWeb.PageController do
  use PlantCareWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    redirect(conn, to: ~p"/plants")
    # render(conn, :home, layout: false)
  end
end
