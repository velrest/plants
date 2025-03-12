defmodule PlantCareWeb.PlantLive.Show do
  use PlantCareWeb, :live_view

  on_mount {PlantCareWeb.LiveUserAuth, :live_user_required}

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Plant {@plant.id}
      <:subtitle>This is a plant record from your database.</:subtitle>

      <:actions>
        <.link patch={~p"/plants/#{@plant}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit plant</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Id">{@plant.id}</:item>
    </.list>

    <.list>
      <:item title="Events">
        <ul :for={event <- @plant.events} :if={not Enum.empty?(@plant.events)}>
          <li>{event.type}</li>
        </ul>

        <span :if={Enum.empty?(@plant.events)}>Empty...</span>

        {@plant.events}

        <.link patch={~p"/plants/#{@plant}/show/add_event"} phx-click={JS.push_focus()}>
          <.button>Add a new event</.button>
        </.link>
      </:item>
    </.list>

    <.back navigate={~p"/plants"}>Back to plants</.back>

    <.modal
      :if={@live_action == :edit}
      id="plant-modal"
      show
      on_cancel={JS.patch(~p"/plants/#{@plant}")}
    >
      <.live_component
        module={PlantCareWeb.PlantLive.FormComponent}
        id={@plant.id}
        title={@page_title}
        action={@live_action}
        current_user={@current_user}
        plant={@plant}
        patch={~p"/plants/#{@plant}"}
      />
    </.modal>
    <.modal
      :if={@live_action == :add_event}
      id="event-modal"
      show
      on_cancel={JS.patch(~p"/plants/#{@plant}")}
    >
      <.live_component
        module={PlantCareWeb.EventLive.FormComponent}
        id={:new}
        title="Add event to Plant"
        current_user={@current_user}
        action={@live_action}
        plant={@plant}
        event={nil}
        patch={~p"/plants/#{@plant}"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(
       :plant,
       Ash.get!(PlantCare.Plants.Plant, id, load: :events, actor: socket.assigns.current_user)
     )}
  end

  defp page_title(:show), do: "Show Plant"
  defp page_title(:edit), do: "Edit Plant"
  defp page_title(:add_event), do: "Add event to plant"
end
