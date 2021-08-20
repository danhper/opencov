defmodule Librecov.ImageMagick do
  def convert(args) do
    command = Application.get_env(:librecov, :imagemagick_convert_path) || "convert"
    System.cmd(command, args)
  end
end
