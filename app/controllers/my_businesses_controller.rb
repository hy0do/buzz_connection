class MyBusinessesController < ApplicationController
  before_action :user_login!
  before_action :find_my_business

  def edit
    (3 - @my_business.business_demand_elements.count).times do
      @my_business.business_demand_elements.build
    end
    (3 - @my_business.business_supply_elements.count).times do
      @my_business.business_supply_elements.build
    end
  end

  def update
    @my_business.assign_attributes(business_params)

    if @my_business.save
      redirect_to action: :edit
    else
      flash.now[:alert] = @my_business.errors.full_messages.first
      render :edit
    end
  end

  private

  def find_my_business
    @my_business = current_user.business
  end

  def business_params
    p = params.require(:business).permit(:name,
                                     :title,
                                     :detail,
                                     :image,
                                     :hp_link,
                                     :prefecture_id,
                                     :status,
                                     business_demand_elements_attributes: [:id, :title, :industry_id, :occupation_id],
                                     business_supply_elements_attributes: [:id, :title, :industry_id, :occupation_id]
    ).to_h

    p['business_demand_elements_attributes'].delete_if do |_k, v|
      v.slice('title', 'industry_id', 'occupation_id').values.any? { |vv| vv.blank? }
    end
    p['business_supply_elements_attributes'].delete_if do |_k, v|
      v.slice('title', 'industry_id', 'occupation_id').values.any? { |vv| vv.blank? }
    end

    p
  end
end
