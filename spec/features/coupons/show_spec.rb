require "rails_helper"

RSpec.describe "merchant coupons show" do

  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Great Clips")

    @coupon_1 = @merchant1.coupons.create!(name: "5% off!", code: "5-P", status: 0, discount_type: 1, discount_value: 5)
    @coupon_2 = @merchant1.coupons.create!(name: "$5 off!", code: "5-D", status: 1, discount_type: 0, discount_value: 5)
    @coupon_3 = @merchant1.coupons.create!(name: "10% off!", code: "10-P", status: 0, discount_type: 1, discount_value: 10)
    @coupon_4 = @merchant1.coupons.create!(name: "$10 off!", code: "10-D", status: 1, discount_type: 0, discount_value: 10)
    @coupon_5 = @merchant1.coupons.create!(name: "25% off!", code: "25-P", status: 0, discount_type: 1, discount_value: 25)
    @coupon_6 = @merchant2.coupons.create!(name: "$25 off!", code: "25-D", status: 1, discount_type: 0, discount_value: 25)
    

    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
    @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
    @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
    @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)
  end

  it "list attributes of that merchant coupon including all the times successfully used" do 
    visit merchant_coupon_path(@merchant1, @coupon_1)

    expect(page).to have_content("Coupon name: #{@coupon_1.name}")
    expect(page).to have_content("Coupon code: #{@coupon_1.code}")
    expect(page).to have_content("Coupon value: #{sprintf('%.2f', @coupon_1.discount_value)}%")
    expect(page).to have_content("Coupon status: #{@coupon_1.status}")
    # require 'pry'; binding.pry
    expect(page).to have_content("Coupon used 0 times")
    # save_and_open_page
    @invoice_8 = @coupon_1.invoices.create!(customer_id: @customer_1.id, status: 2)
    @transaction8 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_8.id)
    # require 'pry'; binding.pry
    visit merchant_coupon_path(@merchant1, @coupon_1)

    expect(page).to have_content("Coupon used 1 times")
  end

  it "provides the option to deactivate if the coupon is activated for that merchant " do 
    visit merchant_coupon_path(@merchant1, @coupon_1)
    
    expect(page).to have_button("Activate")
    expect(page).to_not have_button("Deactivate")
  end
  
  it "allows the merchant to activate the deactivated coupon " do 
    visit merchant_coupon_path(@merchant1, @coupon_1)
    
    click_button "Activate"
    expect(current_path).to eq(merchant_coupon_path(@merchant1, @coupon_1))

    expect(page).to have_content("Coupon status: activated")
    expect(page).to have_button("Deactivate")
  end

  it "allows the merchant to deactivate the activated coupon" do 
    visit merchant_coupon_path(@merchant1, @coupon_2)
    
    click_button "Deactivate"
    expect(current_path).to eq(merchant_coupon_path(@merchant1, @coupon_2))

    expect(page).to have_content("Coupon status: deactivated")
    expect(page).to have_button("Activate")
  end

  it "provides the option to deactivate if the coupon is activated for that merchant " do 
    visit merchant_coupon_path(@merchant1, @coupon_2)
    
    expect(page).to have_button("Deactivate")
    expect(page).to_not have_button("Activate")
  end


end










