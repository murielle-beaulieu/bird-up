class RankingController < ApplicationController

  def index
    user_id = current_user.user_id
    @spottings = Spotting.all
    @user_spottings = @spottings.where(user_id).count
  end
end
