defmodule PlantCareWeb.PlantLive.FormComponent do
  use PlantCareWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage plant records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="plant-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Plant</.button>
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
  def handle_event("validate", %{"plant" => plant_params}, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, plant_params))}
  end

  def handle_event("save", %{"plant" => plant_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: plant_params) do
      {:ok, plant} ->
        notify_parent({:saved, plant})

        socket =
          socket
          |> put_flash(:info, "Plant #{socket.assigns.form.source.type}d successfully")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{plant: plant}} = socket) do
    form =
      if plant do
        AshPhoenix.Form.for_update(plant, :update,
          as: "plant",
          actor: socket.assigns.current_user
        )
      else
        AshPhoenix.Form.for_create(PlantCare.Plants.Plant, :create,
          as: "plant",
          actor: socket.assigns.current_user
        )
      end

    assign(socket, form: to_form(form))
  end
end
