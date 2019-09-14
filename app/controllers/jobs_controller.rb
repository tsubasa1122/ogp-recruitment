class JobsController < ApplicationController
  before_action :authenticate_user!, except: :show
  def index
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new
    if @job.save
      flash[:notice] = "求人がほぞんされました"
      redirect_to @job
    else
      flash[:alert] = "求人の作成に失敗しました"
      render :new
    end
  end

  def show
    @job = Job.find(params[:id])
  end

  private

  def job_params
    params.require(:job).permit(:title, :content).merge(user_id: current_user.id)
  end
end
