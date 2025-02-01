class PagesController < ApplicationController
  def home
    @users = User.order(created_at: :desc).limit(3)
  end

  def about
  end

  def search
    if params[:search].present?
      search_term = "%#{params[:search].downcase}%"
      @users = User.where("LOWER(username) LIKE ?", search_term)
      @articles = Article.where("LOWER(title) LIKE ? OR LOWER(description) LIKE ?", search_term, search_term)
    else
      @users = []
      @articles = []
    end
  end
end