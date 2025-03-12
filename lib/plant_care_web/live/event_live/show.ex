defmodule PlantCareWeb.EventLive.Show do
  use PlantCareWeb, :live_view

  on_mount {PlantCareWeb.LiveUserAuth, :live_user_required}

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Event {@event.id}
      <:subtitle>This is a event record from your database.</:subtitle>

      <:actions>
        <.link patch={~p"/events/#{@event}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit event</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Id">{@event.id}</:item>
    </.list>

    <.back navigate={~p"/events"}>Back to events</.back>

    <.modal
      :if={@live_action == :edit}
      id="event-modal"
      show
      on_cancel={JS.patch(~p"/events/#{@event}")}
    >
      <.live_component
        module={PlantCareWeb.EventLive.FormComponent}
        id={@event.id}
        title={@page_title}
        action={@live_action}
        current_user={@current_user}
        event={@event}
        patch={~p"/events/#{@event}"}
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
     |> assign(:event, Ash.get!(PlantCare.Plants.Event, id, actor: socket.assigns.current_user))}
  end

  defp page_title(:show), do: "Show Event"
  defp page_title(:edit), do: "Edit Event"
end
