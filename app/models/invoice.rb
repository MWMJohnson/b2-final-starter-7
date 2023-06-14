class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  belongs_to :coupon, optional: true
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def gross_profit
    subtotal = total_revenue
    if coupon.present?
      if total_revenue - calc_discount(subtotal) > 0
        total_revenue - calc_discount(subtotal)
      else
        0
      end
    else
      total_revenue
    end
  end

  def calc_discount(subtotal)
    if coupon.percent_off?
      subtotal * (coupon.discount_value / 100.0)
    else
      coupon.discount_value
    end
  end


end
