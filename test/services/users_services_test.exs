defmodule Librecov.UsersServicesTest do
  use Librecov.ModelCase
  alias Librecov.Services.Users

  @new_user_auth %Ueberauth.Auth{
    provider: :github,
    uid: 12345,
    info: %Ueberauth.Auth.Info{
      name: "Ale Ornelas",
      email: "ale@test.com"
    },
    credentials: %Ueberauth.Auth.Credentials{
      expires: true,
      expires_at: 1_629_779_580,
      other: %{},
      refresh_token: "qawsdet5ruyhetyy",
      scopes: [""],
      secret: nil,
      token: "utyityhe4rtrwt",
      token_type: "Bearer"
    }
  }

  test "register new user" do
    {:ok, user} = Users.get_or_register(@new_user_auth)
    assert user.id
  end

  test "integrates existing user" do
    input_user = insert(:user, email: "ale@test.com")

    {:ok, user} = Users.get_or_register(@new_user_auth)
    assert user.id == input_user.id
  end

  test "finds existing user" do
    Users.get_or_register(@new_user_auth)

    {:ok, user} =
      Users.get_or_register(%Ueberauth.Auth{
        @new_user_auth
        | credentials: %Ueberauth.Auth.Credentials{
            expires: true,
            expires_at: 1_629_779_580,
            other: %{},
            refresh_token: "tghsdfasdfsdfad",
            scopes: [""],
            secret: nil,
            token: "yrtyrthdgfsdf",
            token_type: "Bearer"
          }
      })

    assert user.id
  end
end
