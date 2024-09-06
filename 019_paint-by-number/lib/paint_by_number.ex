defmodule PaintByNumber do
  def palette_bit_size(color_count), do: palette_bit_size(color_count, 0)

  def empty_picture(), do: <<>>

  def test_picture(), do: <<0::2, 1::2, 2::2, 3::2>>

  def prepend_pixel(picture, color_count, pixel_color_index) do
    bit_size = palette_bit_size(color_count)
    <<pixel_color_index::size(bit_size), picture::bitstring>>
  end

  def get_first_pixel(picture, _) when picture == <<>>, do: nil

  def get_first_pixel(picture, color_count) do
    bit_size = palette_bit_size(color_count)
    with <<value::size(bit_size), _::bitstring>> <- picture, do: value
  end

  def drop_first_pixel(picture, color_count) do
    bit_size = palette_bit_size(color_count)
    with <<_::size(bit_size), rest::bitstring>> <- picture, do: rest
  end

  def concat_pictures(picture1, picture2), do: <<picture1::bitstring, picture2::bitstring>>

  defp palette_bit_size(color_count, n) do
    if Integer.pow(2, n) < color_count, do: palette_bit_size(color_count, n + 1), else: n
  end
end
