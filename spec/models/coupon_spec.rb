require 'rails_helper'



RSpec.describe Coupon, type: :model do
  before(:each) do 
    @merchant1 = Merchant.create!(name: "Hair Care")
    @coupon_1 = @merchant1.coupons.create!(name: "5% off!", code: "5-P", status: 0, discount_type: 1, discount_value: 5)
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :code }
    it { should validate_presence_of :status }
    it { should validate_presence_of :discount_type }
    it { should validate_presence_of :discount_value }
    it { should validate_uniqueness_of(:code) }
  end

  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoices }
    it { should have_many(:invoice_items).through(:invoices) }
  end
end