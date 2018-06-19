class AnalyzeWorker
  include Sidekiq::Worker

  def perform(repo_id)
    repo = Repository.find repo_id
    ghrepo = Octokit.repository repo.url
    repo.update_attribute(:name, ghrepo.name)
    repo.update_attribute(:stargazers_count, ghrepo.stargazers_count)
    # repo.update_attribute(:forks_count, ghrepo.forks_count)

    @closed_issues = Octokit.list_issues repo.url, state: 'closed'
    @closed_issues_closage_periods = @closed_issues.map { |x| x.closed_at - x.created_at }
    @closed_issues_closage_periods_sorted = @closed_issues_closage_periods.sort

    @closed_issues_average_closage_period = @closed_issues_closage_periods.sum / @closed_issues_closage_periods.size.to_f
    # repo.update_attribute(:forks_count, @closed_issues_average_closage_period)

    repo.update_attribute(:forks_count, @closed_issues_closage_periods_sorted.last)

  end
end
