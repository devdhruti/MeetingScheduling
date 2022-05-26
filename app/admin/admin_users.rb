ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation

  member_action :login do
    user = User.find_by(email: current_admin_user.email)
    sign_in(user)
    redirect_to root_path
  end

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
    column do |m|
      link_to 'login', login_admin_admin_user_path(m)
    end
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
