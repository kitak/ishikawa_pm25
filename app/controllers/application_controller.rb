class ApplicationController < ActionController::Base
  protect_from_forgery

  private 
  def app
    IshikawaPm25::Application.config.appvar
  end
end
