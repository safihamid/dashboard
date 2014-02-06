class FrequentUnsuccessfulLevelSourcesController < ApplicationController
  before_filter :authenticate_user!

  def index
    raise "unauthorized" if !current_user.admin?
  end
end
