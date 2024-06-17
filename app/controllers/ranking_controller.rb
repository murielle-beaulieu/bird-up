class RankingController < ApplicationController

  def index
    @current_user_spottings = Spotting.where(user_id: current_user.id).count
    @rankings = []
    @users = User.all
    @users.each do |user|
      @user_spottings = Spotting.where(user_id: user.id).count
      @rankings << { user: user["username"], spottings: @user_spottings }
    end
    @rankings.sort_by! { |spots| -spots[:spottings] }
    @current_username = current_user.username
    @current_user_rank = @rankings.index { |rank| rank[:user] == @current_username } + 1

  end
end
