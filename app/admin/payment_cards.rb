ActiveAdmin.register PaymentCard do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :stripe_id, :card_brand, :card_exp_month, :card_exp_year, :card_last4, :user_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:stripe_id, :card_brand, :card_exp_month, :card_exp_year, :card_last4, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
