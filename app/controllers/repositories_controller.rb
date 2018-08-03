class RepositoriesController < ApplicationController
  def new
  end

  def show
    @repo = Repository.find(params[:id])
  end

  def create
    @repo = Repository.find_or_create_by(repository_params)
    @repo.save

    if !@repo.analyzed && !@repo.report_in_progress
      run_all_workers @repo.id
    end

    redirect_to @repo
  end

  def report
    @repo = Repository.find(params[:id])
    if (Time.now - @repo.updated_at) > 24.hours
      run_all_workers @repo.id
    end
    redirect_to @repo
  end

  def run_all_workers(repo_id)
    @repo = Repository.find(repo_id)
    @repo.update_attribute :report_in_progress, true

    AnalyzeBasicWorker.perform_async repo_id
    AnalyzeOpenIssuesWorker.perform_async repo_id
    AnalyzeClosedIssuesWorker.perform_async repo_id
    AnalyzeOpenPrsWorker.perform_async repo_id
    AnalyzeClosedPrsWorker.perform_async repo_id
  end

  private

  def repository_params
    params.require(:repository).permit(:address)
  end
end
