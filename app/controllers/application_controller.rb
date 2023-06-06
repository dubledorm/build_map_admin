class ApplicationController < ActionController::Base
  protect_from_forgery

  def access_denied(exception)
    redirect_to root_path, alert: exception.message
  end

  # Метод нужен, иначе возникают проблемы с cancancan
  def current_user
    current_admin_user
  end
end
