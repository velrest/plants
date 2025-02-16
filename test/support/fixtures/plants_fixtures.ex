defmodule PlantCare.PlantsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PlantCare.Plants` context.
  """

  @doc """
  Generate a plant.
  """
  def plant_fixture(attrs \\ %{}) do
    {:ok, plant} =
      attrs
      |> Enum.into(%{

      })
      |> PlantCare.Plants.create_plant()

    plant
  end
end
