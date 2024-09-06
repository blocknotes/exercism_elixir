defmodule SpaceAge do
  @type planet ::
          :mercury
          | :venus
          | :earth
          | :mars
          | :jupiter
          | :saturn
          | :uranus
          | :neptune

  @earth_year_seconds 365.25 * 24 * 60 * 60
  @year_seconds %{
    mercury: @earth_year_seconds * 0.2408467,
    venus: @earth_year_seconds * 0.61519726,
    earth: @earth_year_seconds * 1,
    mars: @earth_year_seconds * 1.8808158,
    jupiter: @earth_year_seconds * 11.862615,
    saturn: @earth_year_seconds * 29.447498,
    uranus: @earth_year_seconds * 84.016846,
    neptune: @earth_year_seconds * 164.79132
  }

  @doc """
  Return the number of years a person that has lived for 'seconds' seconds is
  aged on 'planet', or an error if 'planet' is not a planet.
  """
  @spec age_on(planet, pos_integer) :: {:ok, float} | {:error, String.t()}
  def age_on(planet, seconds) when is_map_key(@year_seconds, planet),
    do: {:ok, (seconds / @year_seconds[planet]) |> Float.round(2)}

  def age_on(_, _), do: {:error, "not a planet"}
end
