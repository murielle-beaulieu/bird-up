class RankingController < ApplicationController

  def index
    @current_user_spottings = Spotting.where(user_id: current_user.id).count
    @rankings = []
    @users = User.all
    @users.each do |user|
      @user_spottings = Spotting.where(user_id: user.id)
      @user_score = 0

      @user_spottings.each do |spotting|
        @user_score += spotting.bird.score
      end
      @rankings << { user: user["username"], score: @user_score }
    end
    @rankings.sort_by! { |spots| -spots[:score] }
    @current_username = current_user.username
    @current_user_rank = @rankings.index { |rank| rank[:user] == @current_username } + 1
  end
end
