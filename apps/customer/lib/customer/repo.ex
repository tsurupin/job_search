defmodule Customer.Repo do
  use Ecto.Repo, otp_app: :customer
  use Scrivener, page_size: 20
end
