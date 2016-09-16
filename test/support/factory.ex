defmodule Opencov.Factory do
  use ExMachina
  use ExMachina.EctoWithChangesetStrategy, repo: Opencov.Repo

  def project_factory do
    %Opencov.Project{
      name: sequence(:name, &("name-#{&1}")),
      base_url: sequence(:base_url, &("https://github.com/tuvistavie/name-#{&1}")),
      current_coverage: 50.0
    }
  end

  def settings_factory do
    %Opencov.Settings{
      signup_enabled: false,
      restricted_signup_domains: nil,
      default_project_visibility: "internal"
    }
  end

  def user_factory do
    %Opencov.User{
      id: sequence(:id, &(&1 + 2)),
      name: sequence(:name, &("name-#{&1}")),
      email: sequence(:email, &("email-#{&1}@example.com")),
      password: "my-secure-password"
    }
  end

  def build_factory do
    %Opencov.Build{
      build_number: sequence(:build_number, &(&1)),
      project: build(:project)
    }
  end

  def job_factory do
    %Opencov.Job{
      job_number: sequence(:job_number, &(&1)),
      build: build(:build)
    }
  end

  def file_factory do
    %Opencov.File{
      job: build(:job),
      name: sequence(:name, &("file-#{&1}")),
      source: "return 0",
      coverage_lines: []
    }
  end

  def badge_factory do
    %Opencov.Badge{
      project: build(:project),
      coverage: 50.0,
      image: "encoded_image",
      format: to_string(Opencov.Badge.default_format)
    }
  end

  def make_changeset(%Opencov.Project{} = project) do
    Opencov.ProjectManager.changeset(project, %{})
  end

  def make_changeset(%Opencov.File{} = file) do
    {job_id, file} = Map.pop(file, :job_id)
    job_id = job_id || file.job.id
    params = Map.from_struct(file)
    job = if job_id do
      Opencov.Repo.get(Opencov.Job, job_id)
    else
      insert(:job)
    end
    file = Ecto.build_assoc(job, :files)
    Opencov.FileManager.changeset(file, params)
  end

  def make_changeset(%Opencov.Build{} = build) do
    {project_id, build} = Map.pop(build, :project_id)
    project_id = project_id || build.project.id
    params = Map.from_struct(build)
    project = if project_id do
      Opencov.Repo.get(Opencov.Project, project_id)
    else
      insert(:project)
    end
    build = Ecto.build_assoc(project, :builds)
    Opencov.BuildManager.changeset(build, params)
  end

  def make_changeset(%Opencov.Job{} = job) do
    {build_id, job} = Map.pop(job, :build_id)
    build_id = build_id || job.build.id
    params = Map.from_struct(job)
    build = if build_id do
      Opencov.Repo.get(Opencov.Build, build_id)
    else
      insert(:build)
    end
    job = Ecto.build_assoc(build, :jobs)
    Opencov.JobManager.changeset(job, params)
  end

  def make_changeset(%Opencov.Badge{} = badge) do
    {project_id, badge} = Map.pop(badge, :project_id)
    params = Map.from_struct(badge)
    project = if project_id do
      Opencov.Repo.get(Opencov.Project, project_id)
    else
      insert(:project)
    end
    badge = Ecto.build_assoc(project, :badge)
    Opencov.BadgeManager.changeset(badge, params)
  end

  def make_changeset(model) do
    model
  end

  def with_project(build) do
    project = insert(:project)
    %{build | project_id: project.id}
  end

  def with_secure_password(user, password) do
    changeset = Opencov.UserManager.changeset(user, %{password: password})
    %{user | password_digest: changeset.changes[:password_digest]}
  end

  def confirmed_user(user) do
    %{user | confirmed_at: Timex.now, password_initialized: true}
  end

  def params_for(factory_name, attrs \\ %{}) do
    ExMachina.Ecto.params_for(__MODULE__, factory_name, attrs)
    |> Enum.reject(fn {_key, value} -> is_nil(value) or value == "" end)
    |> Enum.into(%{})
  end
end
