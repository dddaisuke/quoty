class QuotesController < ApplicationController
  before_filter :require_login, only: [:new, :create, :edit, :update, :destroy, :my, :likes]

  def index
    @quotes = Quote.in(current_user_languages).recent.page(params[:page])
      .with_associations
  end

  def show
    @quote = Quote.find(params[:id])
  end

  def new
    @quote = current_user.quotes.new
    @quote.photos.build
  end

  def create
    @quote = current_user.quotes.new(quote_params)
    if @quote.save
      redirect_to @quote, notice: 'Thanks for sharing!'
    else
      render 'new'
    end
  end

  def edit
    @quote = current_user.quotes.find(params[:id])
    @quote.photos.build unless @quote.photos.exists?
  end

  def update
    @quote = current_user.quotes.find(params[:id])

    if @quote.update(quote_params)
      redirect_to @quote, notice: 'updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @quote = current_user.quotes.find(params[:id])

    if @quote.destroy
      redirect_to root_url, notice: 'destroyed.'
    end
  end

  def popular
    @quotes = Quote.popular.in(current_user_languages).page(params[:page])
      .with_associations

    render :index
  end

  def my
    @quotes = current_user.quotes.recent.page(params[:page])
      .with_associations

    render :index
  end

  def likes
    @quotes = Quote.liked_by(current_user).recent.page(params[:page])
      .with_associations

    render :index
  end

  private

  def quote_params
    # FIXME fix this shit
    params[:quote].tap do |quote|
      if quote[:author_id].blank? || (params[:action] == 'update' && @quote.author.try(:name) != quote[:author_name])
        quote.delete(:author_id)
      end
    end

    params.require(:quote).permit(:content, :language, :author_name, :source,
      :context, :author_id, :source_wiki_id,
      photos_attributes: [:file, :file_cache, :_destroy, :id])
  end
end
