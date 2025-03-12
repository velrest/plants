defmodule PlantCareWeb.PlantLive.Index do
  use PlantCareWeb, :live_view

  on_mount {PlantCareWeb.LiveUserAuth, :live_user_required}

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing your Plants
      <:actions>
        <.link patch={~p"/plants/new"}>
          <.button>New Plant</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="plants"
      rows={@streams.plants}
      row_click={fn {_id, plant} -> JS.navigate(~p"/plants/#{plant}") end}
    >
      <:col :let={{_id, plant}} label="Name">{plant.name}</:col>

      <:action :let={{_id, plant}}>
        <div class="sr-only">
          <.link navigate={~p"/plants/#{plant}"}>Show</.link>
        </div>

        <.link patch={~p"/plants/#{plant}/edit"}>Edit</.link>
      </:action>

      <:action :let={{id, plant}}>
        <.link
          phx-click={JS.push("delete", value: %{id: plant.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="plant-modal"
      show
      on_cancel={JS.patch(~p"/plants")}
    >
      <.live_component
        module={PlantCareWeb.PlantLive.FormComponent}
        id={(@plant && @plant.id) || :new}
        title={@page_title}
        current_user={@current_user}
        action={@live_action}
        plant={@plant}
        patch={~p"/plants"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(:plants, Ash.read!(PlantCare.Plants.Plant, actor: socket.assigns[:current_user]))
     |> assign_new(:current_user, fn -> nil end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Plant")
    |> assign(:plant, Ash.get!(PlantCare.Plants.Plant, id, actor: socket.assigns.current_user))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Plant")
    |> assign(:plant, nil)
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
    plant = Ash.get!(PlantCare.Plants.Plant, id, actor: socket.assigns.current_user)
    Ash.destroy!(plant, actor: socket.assigns.current_user)

    {:noreply, stream_delete(socket, :plants, plant)}
  end
end
