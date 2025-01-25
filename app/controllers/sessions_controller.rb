class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      render json: { user: user }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
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
