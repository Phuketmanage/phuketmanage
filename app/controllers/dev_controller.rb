# frozen_string_literal: true

class DevController < ApplicationController
  def unlock
    user = User.find_by(id: params[:user_id]) || User.first
    sign_in user, bypass_sign_in: true
    redirect_to root_path
  end
end
