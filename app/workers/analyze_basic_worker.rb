class AnalyzeBasicWorker
  include Sidekiq::Worker

  def perform(repo_id)
    repo = Repository.find repo_id

    client = Octokit::Client.new access_token: '8efaaa3ac27d4abdda30d0bbe0ee3f4e4478a7a8'

    ghrepo = client.repository repo.address

    # =====================
    # GENERAL INFO
    repo.update_attribute :stargazers_count, ghrepo.stargazers_count
    repo.update_attribute :forks_count, ghrepo.forks_count

    repo.update_attribute :about, ghrepo.description
    repo.update_attribute :repo_created_at, ghrepo.created_at
    repo.update_attribute :repo_updated_at, ghrepo.updated_at
    if ghrepo.license
      repo.update_attribute :license, ghrepo.license.name
      repo.update_attribute :license_url, ghrepo.license.url
    end

    contributors = client.contributors repo.address
    contributors_incl_anon = client.contributors repo.address, true

    repo.update_attribute :contributors, contributors.count
    repo.update_attribute :contributors_incl_anon, contributors_incl_anon.count

    # =====================
    # DOCUMENTATION
    begin
      @readme = client.readme repo.address
    rescue Exception => e
    end

    if @readme
      repo.update_attribute :readme_lenght, @readme.size
      repo.update_attribute :readme_url, @readme.html_url
    end

    repo.update_attribute :has_wiki, ghrepo.has_wiki

    # =====================
    # OWNER
    repo.update_attribute :owner, ghrepo.owner.login
    repo.update_attribute :owner_url, ghrepo.owner.html_url

    FinalizeReportWorker.perform_async repo_id
  end
end
