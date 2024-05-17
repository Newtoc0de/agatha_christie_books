class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # Helpers
  include BookHelper
end
