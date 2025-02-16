defmodule PlantCareWeb.PlantLive.Index do
  use PlantCareWeb, :live_view

  alias PlantCare.Plants
  alias PlantCare.Plants.Plant

  @impl true
  def mount(_params, _session, socket) do
    {:ok, plants} = Plants.read_plants()
    IO.inspect(plants)
    {:ok, stream(socket, :plants, plants)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    {:ok, plant} = Plants.get_plant(id)
    socket
    |> assign(:page_title, "Edit Plant")
    |> assign(:plant, plant)
  end
  defp apply_action(socket, _, _) do
    socket
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Plant")
    |> assign(:plant, %Plant{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Plants")
    |> assign(:plant, nil)
  end

  @impl true
  def handle_info({PlantCareWeb.PlantLive.FormComponent, {:saved, plant}}, socket) do
    {:noreply, stream_insert(socket, :plants, plant)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    {:ok, plant} = Plants.get_plant(id)
    {:ok, _} = Plants.destroy_plant(plant)

    {:noreply, stream_delete(socket, :plants, plant)}
  end
end
