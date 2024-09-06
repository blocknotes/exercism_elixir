defmodule FileSniffer do
  @format_mismatch "Warning, file format and file extension do not match."

  def type_from_extension(extension) do
    with %{media: media} <- Enum.find(mapping(), nil, fn item -> item.ext == extension end),
         do: media
  end

  def type_from_binary(file_binary) do
    with %{media: media} <- lookup_type_from_content(file_binary), do: media
  end

  def verify(file_binary, ext) do
    type = lookup_type_from_content(file_binary)

    if type != nil and type.ext == ext, do: {:ok, type.media}, else: {:error, @format_mismatch}
  end

  defp lookup_type_from_content(file_binary) do
    Enum.find(mapping(), nil, fn item ->
      sig_size = byte_size(item.signature)
      header = with <<chunk::binary-size(sig_size), _::binary>> <- file_binary, do: chunk
      header == item.signature
    end)
  end

  defp mapping do
    [
      %{
        type: "ELF",
        ext: "exe",
        media: "application/octet-stream",
        signature: <<0x7F, 0x45, 0x4C, 0x46>>
      },
      %{type: "BMP", ext: "bmp", media: "image/bmp", signature: <<0x42, 0x4D>>},
      %{
        type: "PNG",
        ext: "png",
        media: "image/png",
        signature: <<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A>>
      },
      %{type: "JPG", ext: "jpg", media: "image/jpg", signature: <<0xFF, 0xD8, 0xFF>>},
      %{type: "GIF", ext: "gif", media: "image/gif", signature: <<0x47, 0x49, 0x46>>}
    ]
  end
end
