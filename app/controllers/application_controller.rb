class ApplicationController < ActionController::Base
  protect_from_forgery
  around_action :add_organization, only: :create, if: proc { controller_path == 'active_admin/devise/registrations' }

  def add_organization
    response = Client::Services::Registration.call('Заполните пожалуйста имя организации',
                                                   params.required('admin_user')['email'],
                                                   params.required('admin_user')['password'],
                                                   params.required('admin_user')['password_confirmation'])
    if response[:error_code] == -2
      @resource = response[:admin_user]
      render :new
    end

    redirect_to admin_admin_user_path(id: response[:admin_user_id])
  end

  def access_denied(exception)
    redirect_to root_path, alert: exception.message
  end
end
