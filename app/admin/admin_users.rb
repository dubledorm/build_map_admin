ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, roles_attributes: %i[id name]

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      #     f.input :password
      #    f.input :password_confirmation
    end

    # f.inputs do
    #   f.has_many :roles, allow_destroy: true do |role|
    #     role.input :name,
    #                as: :select,
    #                collection: RoleDecorator.translate_role_names
    #   end
    # end

    f.actions
  end

  show do
    panel AdminUser.model_name.human do
      attributes_table_for admin_user do
        row :email
        row :organization
        row :reset_password_token
        row :reset_password_sent_at
        row :remember_created_at
        row :created_at
        row :updated_at
      end
    end

    panel Role.model_name.human do
      table_for resource.roles do
        column :name do |role|
          role.decorate.name
        end
      end
    end
  end

  controller do

    def create
      response = Client::Users::Services::AddUser.client_user(current_admin_user.organization_id,
                                                              params.required(:admin_user).required(:email))
      @resource = response.user
      return render :new, alert: response.message unless response.success?

      redirect_to admin_admin_user_path(id: @resource.id)
    end
  end
end
