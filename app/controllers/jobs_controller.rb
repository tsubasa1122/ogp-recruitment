class JobsController < ApplicationController
  before_action :authenticate_user!, except: :show
  def index
  end

  def new
  end

  def create
  end

  def show
  end
end
