class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      session[:user_id] = user.id
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Successfully logged in." }
        format.json { render json: { user: user }, status: :created }
      end
    else
      flash[:notice] = "Invalid email or password."
      render :new
    end
  end

  def new
  end

  def destroy
    session.delete :user_id
    head :no_content
  end

  def current_user
    if session[:user_id]
      user = User.find(session[:user_id])
      render json: { user: user }
    else
      render json: { error: 'No current user' }, status: :unauthorized
    end
  end

  def logged_in?
    if session[:user_id]
      render json: { logged_in: true }
    else
      render json: { logged_in: false }
    end
  end
end
