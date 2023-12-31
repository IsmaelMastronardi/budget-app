class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    redirect_to user_groups_path(current_user) if current_user
  end
end
