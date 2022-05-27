class Invoice < ApplicationRecord
  has_many :invoice_items
  has_many :transactions
end
