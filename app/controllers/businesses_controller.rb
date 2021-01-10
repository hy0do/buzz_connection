class BusinessesController < ApplicationController
  def index
    ids = [BusinessSupplyElement, BusinessDemandElement].map do |klass|
      i_ids = klass.where(industry_id: params[:industry_id]).pluck(:business_id) if params[:industry_id]
      o_ids = klass.where(occupation_id: params[:occupation_id]).pluck(:business_id) if params[:occupation_id]
      i_ids | o_ids
    end.flatten.uniq

    @businesses = Business.published
                          .yield_self { |q| [params[:occupation_id], params[:industry_id]].any?(&:present?) ? q.where(id: ids) : q }
                          .yield_self { |q| user_login? ? q.where.not(id: current_user.business.id) : q }
  end

  def show
   my_business = current_user&.business
   @business = if my_business.present? && my_business.code == params[:code]
     current_user.business
   else
     Business.published.find_by!(code: params[:code])
   end
  end

  class BusinessSearchService
    def initialize(businesses)
      @businesses = businesses
    end

    def search
    end
  end
end
