# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def index; end
end
