defmodule RobotSimulator do
  defstruct [:direction, :position]

  @turn_right %{north: :east, east: :south, south: :west, west: :north}
  @turn_left %{north: :west, west: :south, south: :east, east: :north}

  @type robot() :: any()
  @type direction() :: :north | :east | :south | :west
  @type position() :: {integer(), integer()}

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction, position) :: robot() | {:error, String.t()}
  def create(direction \\ :north, position \\ {0, 0}) do
    cond do
      not valid_position?(position) -> {:error, "invalid position"}
      not valid_direction?(direction) -> {:error, "invalid direction"}
      true -> %__MODULE__{direction: direction, position: position}
    end
  end

  defp valid_position?({x, y}) when is_integer(x) and is_integer(y), do: true
  defp valid_position?(_), do: false

  defp valid_direction?(direction), do: direction in [:north, :east, :south, :west]

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot, instructions :: String.t()) :: robot() | {:error, String.t()}
  def simulate(robot, instructions) do
    if valid_instructions?(instructions),
      do: String.graphemes(instructions) |> Enum.reduce(robot, &simulate_instruction/2),
      else: {:error, "invalid instruction"}
  end

  defp valid_instructions?(instructions), do: instructions =~ ~r/\A[ALR]+\z/

  defp simulate_instruction("R", robot),
    do: %__MODULE__{robot | direction: @turn_right[robot.direction]}

  defp simulate_instruction("L", robot),
    do: %__MODULE__{robot | direction: @turn_left[robot.direction]}

  defp simulate_instruction("A", robot),
    do: %__MODULE__{robot | position: advance(robot.position, robot.direction)}

  defp advance({x, y}, :north), do: {x, y + 1}
  defp advance({x, y}, :east), do: {x + 1, y}
  defp advance({x, y}, :south), do: {x, y - 1}
  defp advance({x, y}, :west), do: {x - 1, y}

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot) :: direction()
  def direction(robot), do: robot.direction

  @doc """
  Return the robot's position.
  """
  @spec position(robot) :: position()
  def position(robot), do: robot.position
end
