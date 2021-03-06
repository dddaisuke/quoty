class CommentsController < ApplicationController
  before_filter :require_login

  def new
    @quote = Quote.find(params[:quote_id])
  end

  def create
    @quote = Quote.find(params[:quote_id])
    @comment = @quote.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.html { redirect_to @quote, notice: I18n.t('comments.create.success') }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
