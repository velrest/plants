defmodule PlantCareWeb.EventLive.Index do
  use PlantCareWeb, :live_view

  on_mount {PlantCareWeb.LiveUserAuth, :live_user_required}

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Events
      <:actions>
        <.link patch={~p"/events/new"}>
          <.button>New Event</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="events"
      rows={@streams.events}
      row_click={fn {_id, event} -> JS.navigate(~p"/events/#{event}") end}
    >
      <:col :let={{_id, event}} label="Date">{Calendar.strftime(event.date, "%d.%m.%y")}</:col>
      <:col :let={{_id, event}} label="Event">{event.type}</:col>

      <:action :let={{_id, event}}>
        <div class="sr-only">
          <.link navigate={~p"/events/#{event}"}>Show</.link>
        </div>

        <.link patch={~p"/events/#{event}/edit"}>Edit</.link>
      </:action>

      <:action :let={{id, event}}>
        <.link
          phx-click={JS.push("delete", value: %{id: event.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="event-modal"
      show
      on_cancel={JS.patch(~p"/events")}
    >
      <.live_component
        module={PlantCareWeb.EventLive.FormComponent}
        id={(@event && @event.id) || :new}
        title={@page_title}
        current_user={@current_user}
        action={@live_action}
        event={@event}
        patch={~p"/events"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(:events, Ash.read!(PlantCare.Plants.Event, actor: socket.assigns[:current_user]))
     |> assign_new(:current_user, fn -> nil end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Event")
    |> assign(:event, Ash.get!(PlantCare.Plants.Event, id, actor: socket.assigns.current_user))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Event")
    |> assign(:event, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Events")
    |> assign(:event, nil)
  end

  @impl true
  def handle_info({PlantCareWeb.EventLive.FormComponent, {:saved, event}}, socket) do
    {:noreply, stream_insert(socket, :events, event)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    event = Ash.get!(PlantCare.Plants.Event, id, actor: socket.assigns.current_user)
    Ash.destroy!(event, actor: socket.assigns.current_user)

    {:noreply, stream_delete(socket, :events, event)}
  end
end
