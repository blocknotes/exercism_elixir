defmodule DancingDots.Animation do
  @type dot :: DancingDots.Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  @callback init(opts()) :: {:ok, opts()} | {:error, error()}
  @callback handle_frame(dot(), frame_number(), opts()) :: dot()

  defmacro __using__(_) do
    quote do
      @behaviour DancingDots.Animation

      def init(options), do: {:ok, options}

      defoverridable init: 1
    end
  end
end

defmodule DancingDots.Flicker do
  use DancingDots.Animation

  @impl DancingDots.Animation
  def handle_frame(%DancingDots.Dot{opacity: opacity} = dot, frame_number, _) do
    if rem(frame_number, 4) == 0,
      do: %{dot | opacity: opacity / 2},
      else: dot
  end
end

defmodule DancingDots.Zoom do
  use DancingDots.Animation

  @impl DancingDots.Animation
  def init(options) do
    if !Keyword.has_key?(options, :velocity) || !is_number(options[:velocity]) do
      message =
        "The :velocity option is required, and its value must be a number. Got: #{inspect(options[:velocity])}"

      {:error, message}
    else
      {:ok, options}
    end
  end

  @impl DancingDots.Animation
  def handle_frame(%DancingDots.Dot{radius: radius} = dot, frame_number, options) do
    if frame_number > 1,
      do: %{dot | radius: radius + (frame_number - 1) * options[:velocity]},
      else: dot
  end
end
