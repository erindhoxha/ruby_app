class PagesController < ApplicationController
  def home
    @users = User.order(created_at: :desc).limit(3)
  end

  def about
  end

  def search
    if params[:search].present?
      @users = User.where("username LIKE ?", "%#{params[:search]}%")
      @articles = Article.where("title LIKE ? OR description LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
    else
      @users = []
      @articles = []
    end
  end
end