class UsersController < ApplicationController
  rescue_from 'ActionController::ParameterMissing' do |e|
    render json: {
             error_message: "Missing parameter: #{e.param}",
           },
           status: :bad_request
  end

  skip_before_action :verify_authenticity_token

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
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
