class SettingsController < ApplicationController
  before_action :authenticate_user!
  include TickerConcern

  def settings
    @symbols = TickerConcern.symbols
    @user = current_user
  end

  def post_settings
    @user = current_user
    @user.update settings_params
    if @user.save
      flash[:notice] = "Settings save."
      redirect_to action: 'settings'
    else
      @symbols = TickerConcern.symbols
      render 'settings'
    end
  end

  private

  def settings_params
    params.require(:user).permit(:reference_precision, :reference_character, :reference_symbol)
  end

end
