defmodule PlantCareWeb.EventLive.FormComponent do
alias Ash.Changeset
  use PlantCareWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage event records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="event-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:type]}
          type="select"
          label="Type"
          options={Ash.Resource.Info.attribute(PlantCare.Plants.Event, :type).constraints[:one_of]}
        />

        <.input
          field={@form[:date]}
          type="date"
          label="Date"
        />

        <:actions>
          <.button phx-disable-with="Saving...">Save Event</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form()}
  end

  @impl true
  def handle_event("validate", %{"event" => event_params}, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, event_params))}
  end

  def handle_event("save", %{"event" => event_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: event_params) do
      {:ok, event} ->
        notify_parent({:saved, event})

        socket =
          socket
          |> put_flash(:info, "Event #{socket.assigns.form.source.type}d successfully")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{event: event, plant: plant}} = socket) do
    form =
      if event do
        AshPhoenix.Form.for_update(event, :update,
          as: "event",
          actor: socket.assigns.current_user
        )
      else
        AshPhoenix.Form.for_create(PlantCare.Plants.Event, :create,
          as: "event",
          actor: socket.assigns.current_user,
          prepare_source: &Changeset.change_attribute(&, :plant, plant)
        )
      end

    assign(socket, form: to_form(form))
  end
end
