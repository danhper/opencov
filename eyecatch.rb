before_script do
  run 'gpasswd -a postgres ssl-cert'
  run 'ls -l /etc/ssl/private'
  run 'ls -l /etc/ssl/private/*'
  run 'id postgres'
  run 'cat /etc/init.d/postgresql'
  run '/etc/init.d/postgresql start'
  run 'wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb'
  run 'dpkg -i erlang-solutions_1.0_all.deb'
  run 'apt-get update'
  run 'apt-get install -y elixir'
  run 'mix local.hex --force'
  run 'mix local.rebar --force'
  run 'mix compile'
  run 'mix ecto.create'
  run 'mix ecto.migrate'
  run 'mix run priv/repo/seeds.exs'
end

serve 'mix phoenix.server'
port 4000

window_width 1200

start_delay 10

env 'MIX_ENV=development'

state(:user) do
  before_access('/login') do
    fill_in 'login[email]', with: 'admin@example.com'
    fill_in 'login[password]', with: 'p4ssw0rd'
    click_button 'Login'
  end
  entry_point '/login'
end
