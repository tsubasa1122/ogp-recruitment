class JobsController < ApplicationController
  before_action :authenticate_user!, except: :show
  def index
    @jobs = Job.all.includes(:user).where(user_id: current_user.id)
    @entries = Entry.all.includes(:user, :job)
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
    image = Magick::ImageList.new('./public/base_image.png')
    draw = Magick::Draw.new
    title = cut_text(@job.title)
    draw.annotate(image, 0, 0, 0, -120, title) do
      self.font = 'app/assets/NotoSansJP-Bold.otf'   #別のフォントをダウンロードした方はNotoSansJP-Bold.otfを変更
      self.fill = '#000'
      self.gravity = Magick::CenterGravity
      self.font_weight = Magick::BoldWeight
      self.stroke = 'transparent'
      self.pointsize = 48
    end
    image_path = image.write(uniq_file_name).filename
    image_url = cut_path(image_path)
    @job.image_url = image_url

    if @job.save
      flash[:notice] = "求人がほぞんされました"
      redirect_to @job
    else
      flash[:alert] = "求人の作成に失敗しました"
    end
  end

  def show
    @job = Job.find(params[:id])
    @entries = Entry.where(job_id: @job)
  end

  private

  def job_params
    params.require(:job).permit(:title, :content).merge(user_id: current_user.id)
  end

  def cut_path(url)
    url.sub(/\.\/public\//, "")
  end

  def uniq_file_name
    "./public/#{SecureRandom.hex}.png"
  end

  def cut_text(text)
      text.scan(/.{1,15}/).join("\n")
  end
end
