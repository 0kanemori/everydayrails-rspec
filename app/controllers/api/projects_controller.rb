module Api
  class ProjectsController < Api::ApplicationController

    def index
      @projects = current_user.projects
      render json: @projects
    end

    def show
      @project = Project.find(params[:id])
      render json: @project
    end

    def create
      @project = current_user.projects.new(project_params)

      if @project.save
        render json: { status: :created }
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    end

    private

    def project_params
      params.require(:project).permit(:name, :description, :due_on)
    end
  end
end
