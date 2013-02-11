class UsersController < ApplicationController
  before_filter :require_login, except: :show

  def show
    @user = User.find(params[:id])
    @activities = @user.activities.order('created_at DESC').limit(10)

    respond_to do |format|
      format.html
      format.json { render json: @user.quotes.to_json }
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update_attributes(params[:user])
      redirect_to @user, notice: t('users.update.success')
    else
      render :edit
    end
  end

  # TODO it should be changed to current_user's friends list.
  # also every key down event will trigger a query so it's bad for performance.
  def friends_names
    render text: User.where("name LIKE ?", "%#{params[:q]}%").pluck(:name)
  end
end