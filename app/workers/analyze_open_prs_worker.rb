class AnalyzeOpenPrsWorker
  include Sidekiq::Worker

  def perform(repo_id)
    repo = Repository.find repo_id

    client = Octokit::Client.new access_token: 'd6e541654ef87bf2174f7b98948b204ca57cb389'

    # OPEN PULL REQUESTS
    @open_prs = client.pull_requests repo.address, state: 'open', per_page: 100
    repo.update_attribute :open_pr_count, @open_prs.count
    @time_now = Time.now

    @open_prs_ages = @open_prs.map { |x| @time_now - x.created_at }
    @open_prs_ages.extend DescriptiveStatistics

    repo.update_attribute :average_open_prs_age, @open_prs_ages.mean
    repo.update_attribute :median_open_prs_age, @open_prs_ages.median
    repo.update_attribute :min_open_prs_age, @open_prs_ages.min
    repo.update_attribute :max_open_prs_age, @open_prs_ages.max

    FinalizeReportWorker.perform_async repo_id
  end
end
