class PagesController < ApplicationController
  def home
    @users = User.order(created_at: :desc).limit(3)
  end

  def about
  end
end