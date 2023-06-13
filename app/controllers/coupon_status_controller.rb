class CouponStatusController < ApplicationController
  def update
    @merchant = Merchant.find(params[:merchant_id])
    @coupon = Coupon.find(params[:id])
    @coupon.update(coupon_status_params)
    redirect_to merchant_coupons_path
  end

  private
  def coupon_status_params
    params.permit(:status)
  end
end
