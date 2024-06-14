class RankingController < ApplicationController

  def index
    @user_spottings = Spotting.where(user_id: current_user.id).count
  end
end
