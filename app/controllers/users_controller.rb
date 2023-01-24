class UsersController < ApplicationController
  # GET /users
  def index
    # Can be improved by using a pagination and caching warm up
    @users = []
    User.includes(:images).joins(:images).find_each { |user| @users << user }
  end

  # GET /users/1
  def show
    @user = User.find_by(id: params[:id])
  end

  # POST /users
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.json { render :show, status: :created, location: @user }
      else
        format.json { render :error, status: :unprocessable_entity }
      end
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email)
  end
end
