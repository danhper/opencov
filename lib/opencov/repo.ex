defmodule Opencov.Repo do
  use Ecto.Repo, otp_app: :opencov
  use Scrivener, page_size: 10
end
