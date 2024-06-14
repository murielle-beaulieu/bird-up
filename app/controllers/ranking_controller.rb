class RankingController < ApplicationController

  def index
    user_id = current_user.id
    @user_spottings = Spotting.where(user_id: user_id).count
  end
end
