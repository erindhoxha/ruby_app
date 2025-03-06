class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy]
  before_action :require_user, except: [:index, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  # GET /articles or /articles.json
  def index
    @articles = current_user&.articles&.paginate(page: params[:page], per_page: 5)
  end

  # GET /articles/1 or /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)
    @article.user = current_user
    fetch_metadata(@article) if @article.url.present?

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    # Update the article with the new URL first
    if article_params[:url].present?
      @article.assign_attributes(article_params)
      fetch_metadata(@article)
    end

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_path, status: :see_other, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :description, :url)
    end

    def require_same_user
      if current_user != @article.user && !current_user.admin?
        flash[:alert] = "You can only edit or delete your own articles"
        redirect_to @article
      end
    end

    def fetch_metadata(article)
      require 'open-uri'
      require 'nokogiri'
    
      begin
        Rails.logger.debug "Fetching metadata for URL: #{article.url}"
        # Set a user-agent header to mimic a browser request
        options = {
          "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
        }
        doc = Nokogiri::HTML(URI.open(article.url, options))
        
        # Fetch og:title and assign it to description if present
        og_title = doc.at('meta[property="og:title"]')&.[]('content')
        article.description = og_title || doc.at('title')&.text
        Rails.logger.debug "Fetched description (og:title): #{article.description}"
        
        # Fetch og:image
        article.og_image = doc.at('meta[property="og:image"]')&.[]('content')
        article.og_image ||= doc.at('#landingImage')&.[]('src')
        Rails.logger.debug "Fetched og_image: #{article.og_image}"
        
        # Fetch og:description
        article.og_description = doc.at('meta[property="og:description"]')&.[]('content')
        Rails.logger.debug "Fetched og_description: #{article.og_description}"
      rescue OpenURI::HTTPError => e
        Rails.logger.error "HTTP Error: #{e.message}"
      rescue StandardError => e
        Rails.logger.error "Error fetching metadata: #{e.message}"
      end
    end
end