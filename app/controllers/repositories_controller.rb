class RepositoriesController < ApplicationController
  def new
  end

  def show
    @repo = Repository.find(params[:id])
  end

  def create
    @repo = Repository.find_or_create_by(repository_params)
    @repo.save
    AnalyzeWorker.perform_async(@repo.id)
    redirect_to @repo
  end

  private
    def repository_params
      params.require(:repository).permit(:url)
    end
end
