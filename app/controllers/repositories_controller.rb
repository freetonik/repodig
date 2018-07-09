class RepositoriesController < ApplicationController
  def new
  end

  def show
    @repo = Repository.find(params[:id])
  end

  def create
    @repo = Repository.find_or_create_by(repository_params)
    @repo.save

    if @repo.analyzed
      if (Time.now - @repo.updated_at) > 24.seconds
        AnalyzeWorker.perform_async(@repo.id)
      end
    else
      AnalyzeWorker.perform_async(@repo.id)
    end

    redirect_to @repo
  end

  def report
    @repo = Repository.find(params[:id])
    if (Time.now - @repo.updated_at) > 24.seconds
      @repo.update_attribute(:report_in_progress, true)
      AnalyzeWorker.perform_async(@repo.id)
    end
    redirect_to @repo
  end

  private
    def repository_params
      params.require(:repository).permit(:address)
    end
end
