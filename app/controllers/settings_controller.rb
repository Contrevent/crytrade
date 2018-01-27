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

  def dashboard
    @tiles = Tile.where(user: current_user).order(:position)
    @screeners = Screener.where(user: current_user).map {|screen| [screen.name, screen.id]}
    @action = (params.key? :id) ? 'update' : 'create'
    @tile = @action == 'update' ? Tile.find(params[:id]) : Tile.new
  end

  def new_tile
    @tile = Tile.create(new_tile_params)
    new_order = Tile.where(user: current_user).maximum(:position)
    if new_order == nil
      new_order = 1
    else
      new_order += 1
    end
    @tile.position = new_order
    @tile.user = current_user
    unless @tile.save
      flash[:error] = 'Something went wrong'
    end
    redirect_to action: 'dashboard'
  end

  def update_tile
    @title = Tile.find(params[:id])
    if @title != nil
      @title.update(new_tile_params)
      redirect_to action: 'dashboard', id: params[:id]
    else
      redirect_to action: 'dashboard'
    end
  end

  def destroy_tile
    @title = Tile.find(params[:id])
    if @title != nil
      @title.destroy
    end
    redirect_to action: 'dashboard'
  end

  def move_tile
    source_tile = Tile.find(params[:id])
    if source_tile != nil
      up = (params[:dir] == 'up')
      source_order = source_tile.position
      if up
        target_tile = Tile.where('user_id = ? and position < ?', current_user.id, source_order).order('position desc').first
      else
        target_tile = Tile.where('user_id = ? and position > ?', current_user.id, source_order).order('position asc').first
      end

      if target_tile != nil
        if up
          source_tile.position = source_order - 1
          target_tile.position = source_order + 1
        else
          source_tile.position = source_order + 1
          target_tile.position = source_order - 1
        end
        source_tile.save
        target_tile.save
      end
    end
    redirect_to action: 'dashboard'
  end

  def screener_name(tile)
    if tile.kind == 'screener_last'
      return ' ' + @screeners.select {|screen| screen[1] == tile.ref_id}.first[0]
    end
    ''
  end

  helper_method :screener_name

  private

  def settings_params
    params.require(:user).permit(:reference_precision, :reference_character, :reference_symbol)
  end

  def new_tile_params
    params.require(:tile).permit(:kind, :ref_id, :width, :height)
  end


end
