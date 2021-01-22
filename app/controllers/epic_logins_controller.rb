class EpicLoginsController < ApplicationController
  def show
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(user_params)

    redirect_to epic_logins_path
  end

  private

  def user_params
    params.fetch(:user, {}).permit(:epic_username, :epic_password)
  end
end
