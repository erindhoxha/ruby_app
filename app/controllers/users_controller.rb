class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :require_user, only: [:edit, :update, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  # GET /users or /users.json
  def index
    if current_user
      @current_user = current_user
      @other_users = User.where.not(id: current_user.id).paginate(page: params[:page], per_page: 5)
    else
      @other_users = User.paginate(page: params[:page], per_page: 5)
    end
    @users = User.paginate(page: params[:page], per_page: 5)
  end
  
  # GET /users/1 or /users/1.json
  def show
    @articles = @user.articles.order(created_at: :desc)
    Rails.logger.debug "User: #{@user.inspect}"
    Rails.logger.debug "Articles: #{@articles.inspect}"
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to articles_path, notice: "Welcome, #{@user.username}" }
        format.json { render :show, status: :created, location: @user }
        session[:user_id] = @user.id
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    session.delete(:user_id)
    respond_to do |format|
      format.html { redirect_to users_path, status: :see_other, notice: "User was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end

    def require_same_user
      if current_user != @user && !current_user.admin?
        flash[:alert] = "You can only edit or delete your own articles"
        redirect_to @user
      end
    end
end