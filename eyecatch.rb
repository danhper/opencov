before_build do
  run 'locale-gen en_US.UTF-8'
  run 'wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb'
  run 'dpkg -i erlang-solutions_1.0_all.deb'
  run 'apt-get update'
  run 'apt-get install -y elixir erlang-dev erlang-parsetools'
  run 'mix local.hex --force'
  run 'mix local.rebar --force'
  run 'mix deps.get'
  run 'mix compile'
  run 'mix ecto.create'
  run 'mix ecto.migrate'
  run 'mix run priv/repo/seeds.exs'
end

service 'postgresql'

serve 'mix phoenix.server'
port 4000

window_width 1200

start_delay 10

task('anonymous') do
  entry_point '/'
end

task('user') do
  before_capture('/login') do
    fill_in 'login[email]', with: 'admin@example.com'
    fill_in 'login[password]', with: 'p4ssw0rd'
    click_button 'Login'
  end
  entry_point '/login'
end

env 'MIX_ENV=dev'
env 'LANG=en_US.UTF-8'
env 'LANGUAGE=en_US:en'
env 'LC_ALL=en_US.UTF-8'
