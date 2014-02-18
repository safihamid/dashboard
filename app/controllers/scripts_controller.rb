class ScriptsController < ApplicationController
  before_filter :authenticate_user!
  check_authorization

  def index
    authorize! :show, Script
    # Show all the scripts that a user has created.
    @scripts = Script.where(user: current_user)
  end

  def new
    authorize! :manage, Script
    @script = Script.new
  end

  def create
    authorize! :manage, Script
    params[:script].require(:name)
    script = Script.create!(name: params[:script][:name], user: current_user)
    flash.notice = "You created a new script."
    redirect_to scripts_path
  end

  def edit
    authorize! :manage, Script
    # Add or remove a level at the specified index in the script.
  end

  def destroy
    authorize! :manage, Script
    Script.find(params[:id]).destroy
    flash.notice = "You destroyed a script."
    redirect_to scripts_path
  end
end
