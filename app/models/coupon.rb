class Coupon < ApplicationRecord
  validates_presence_of :name,
                        :code,
                        :status,
                        :discount_type,
                        :discount_value

                      
  belongs_to :merchant
  has_many :invoices
  has_many :invoice_items, through: :invoices

  enum status: [:inactive, :active]
  enum discount_type: [:dollar_off, :percent_off]


end