defmodule Librecov.Authentication.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :librecov,
    error_handler: Librecov.Authentication.ErrorHandler,
    module: Librecov.Authentication

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
