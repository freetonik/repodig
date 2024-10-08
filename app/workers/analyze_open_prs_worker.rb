class AnalyzeOpenPrsWorker
  include Sidekiq::Worker

  def perform(repo_id)
    repo = Repository.find repo_id

    client = Octokit::Client.new access_token: '8efaaa3ac27d4abdda30d0bbe0ee3f4e4478a7a8'

    # OPEN PULL REQUESTS
    @open_prs = client.pull_requests repo.address, state: 'open', per_page: 100
    @time_now = Time.now

    @open_prs_ages = @open_prs.map { |x| @time_now - x.created_at }
    @open_prs_ages.extend DescriptiveStatistics

    repo.update_attribute :average_open_prs_age, @open_prs_ages.mean
    repo.update_attribute :median_open_prs_age, @open_prs_ages.median
    repo.update_attribute :min_open_prs_age, @open_prs_ages.min
    repo.update_attribute :max_open_prs_age, @open_prs_ages.max

    repo.update_attribute :open_pr_count, @open_prs.count
    FinalizeReportWorker.perform_async repo_id
  end
end
