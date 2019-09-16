class EntriesController < ApplicationController
  def create
    @entry = current_user.entries.new(entry_params)
    if @entry.save
      flash[:notice] = "応募が完了しました"
      redirect_to @entry.job
    else
      flash[:alert] = "応募に失敗しました"
      redirect_to :back
    end
  end

  private

  def entry_params
    params.require(:entry).permit(:user_id, :job_id, :message, :status)
  end
end
