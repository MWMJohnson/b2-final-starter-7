class CouponsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @deactivated_coupons = @merchant.deactivated_coupons
    @activated_coupons = @merchant.activated_coupons
  end

  def show
    # require 'pry'; binding.pry
    @coupon = Coupon.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id]) 

    coupon = merchant.coupons.new(coupon_params)
      # name: params[:name],
      # code: params[:code],
      # status: params[:status],
      # discount_type: params[:discount_type],
      # discount_value: params[:discount_value]  
      #                           )

    if coupon.save
      flash.notice = "Succesfully Updated Item Info!"
      redirect_to (merchant_coupons_path(merchant))
    else 
      flash.notice = "You cannot create a new coupon with an already existing code, please try again using a code that does not exist."
      redirect_to (new_merchant_coupon_path(merchant))
    end
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    coupon = Coupon.find(params[:id])
    # require 'pry'; binding.pry
    coupon.update(status: params[:status])
    redirect_to merchant_coupon_path(merchant, coupon)
  end

  private
  def coupon_params
    params.permit(:name, :code, :status, :discount_type, :discount_value)
  end

  # def status_num(param)
  #   if param == "Deactivated"
  #     0
  #   elsif param == "Activated"
  #     1
  #   end
  # end

  # def discount_type_num(param)
  #   if param == "Dollar"
  #     0
  #   elsif param == "Percentage"
  #     1
  #   end
  # end

end