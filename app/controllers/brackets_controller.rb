class BracketsController < ApplicationController

  before_filter :authenticate_user!, only: [:edit, :update, :destroy]

  def show
    @tournament = Tournament.friendly.find(params[:tournament_id])
    authenticate_user! unless @tournament.started?

    @bracket = @tournament.brackets.includes(:user).find(params[:id])
    if @tournament.started? || @bracket.user == current_user
      @bracket = Bracket
        .includes(:user)
        .includes(tournament: { games: [:team1, :team2] })
        .find(@bracket)
    else
      flash[:warning] =
        "You may only see other users' brackets once the tournament starts."
      @forbidden = true
      render status: :forbidden
    end
  end

  def new
    @tournament = Tournament.friendly.find(params[:tournament_id])
    if user_signed_in?
      check_for_existing(@tournament) and return
    end

    if @tournament.started?
      flash[:error] = "Sorry, you may no longer create a bracket."
      redirect_to @tournament and return
    end

    @bracket = @tournament.brackets.build(session[:bracket])
    @bracket.tournament = Tournament
      .includes(games: [:team1, :team2])
      .find(@tournament.id)
    @bracket.picks = JSON.parse(@bracket.picks) if @bracket.picks.is_a? String
  end

  def create
    @tournament = Tournament.friendly.find(params[:tournament_id])
    unless user_signed_in?
      session[:bracket] = params[:bracket]
      session[:user_return_to] =
        new_tournament_bracket_path(@tournament)
      authenticate_user!
    end

    check_for_existing(@tournament) and return
    if @tournament.started?
      flash[:error] = "Sorry, you may no longer create a bracket."
      redirect_to @tournament and return
    end

    @bracket = current_user.brackets.build(
      tournament: @tournament,
      picks: JSON.parse(params[:bracket][:picks])
    )
    if @bracket.save
      flash[:success] = "Your bracket has been created."
      redirect_to [@tournament, @bracket]
    else
      flash[:error] = "There has been an error saving your bracket."
      redirect_to new_tournament_bracket_path(@tournament)
    end
  end

  def update
    @tournament = Tournament.friendly.find(params[:tournament_id])
    @bracket = @tournament.brackets.includes(:user).find(params[:id])
    @bracket.picks = JSON.parse(params[:bracket][:picks])
    if @tournament.started? || @bracket.user != current_user
      head :forbidden
    elsif @bracket.save
      render json: @bracket
    else
      render json: @bracket.errors, status: :unprocessable_entity
    end
  end

  private
  def check_for_existing(tournament)
    @bracket = current_user.brackets
      .find_by_tournament_id(@tournament.id)
    if @bracket
      flash[:info] = "You may only create one bracket per year"
      redirect_to [@tournament, @bracket]
      true
    end
  end
end
