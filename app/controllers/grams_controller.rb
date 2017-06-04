class GramsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
  end

  def new
    @gram = Gram.new
  end

  def create
    @gram = current_user.grams.create(gram_params)
    if @gram.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def gram_params
    params.require(:gram).permit(:message)
  end

  def show
    @gram = Gram.find_by_id(params[:id])
    if @gram.nil?
      render plain: "Gram not found", status: :not_found
    end 
  end

end
