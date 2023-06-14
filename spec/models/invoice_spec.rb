require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should belong_to(:coupon).optional }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end
  describe "instance methods" do
    it "total_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.total_revenue).to eq(100)
    end

    describe "#gross_profit" do
      it "calculates gross profit with a percent based discount" do 
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
        @coupon_1 = @merchant1.coupons.create!(name: "5% off!", code: "5-P", status: 0, discount_type: 1, discount_value: 5)
        @invoice_1 = @coupon_1.invoices.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

        expect(@invoice_1.gross_profit).to eq(95)
      end

      it "calculates gross profit with a dollar based discount" do 
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
        @coupon_6 = @merchant1.coupons.create!(name: "$25 off!", code: "25-D", status: 1, discount_type: 0, discount_value: 25)
        @invoice_1 = @coupon_6.invoices.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

        expect(@invoice_1.gross_profit).to eq(75)
      end

      it "does not allow the merchant to owe the customer money" do 
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        # @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
        @coupon_6 = @merchant1.coupons.create!(name: "$25 off!", code: "25-D", status: 1, discount_type: 0, discount_value: 25)
        @invoice_1 = @coupon_6.invoices.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

        expect(@invoice_1.gross_profit).to eq(0)
      end
    end


    describe "#calc_discount(subtotal)" do
    it "calculates total discount amount to be subtracted with a percent based discount" do 
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @coupon_1 = @merchant1.coupons.create!(name: "5% off!", code: "5-P", status: 0, discount_type: 1, discount_value: 5)
      @invoice_1 = @coupon_1.invoices.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.calc_discount(100)).to eq(5)
    end

    it "calculates total discount amount to be subtracted with a dollar based discount" do 
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @coupon_6 = @merchant1.coupons.create!(name: "$25 off!", code: "25-D", status: 1, discount_type: 0, discount_value: 25)
      @invoice_1 = @coupon_6.invoices.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.calc_discount(100)).to eq(25)
    end
  end
  end
end
