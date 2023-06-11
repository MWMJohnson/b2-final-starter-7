require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :code }
    it { should validate_presence_of :status }
    it { should validate_presence_of :discount_type }
    it { should validate_presence_of :discount_value }

  end

  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoices }
    it { should have_many(:invoice_items).through(:invoices) }
  end
end