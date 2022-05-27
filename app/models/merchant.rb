class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  def self.find_by_name(name)
    Merchant.where("name ILIKE ?", "%" + name + "%").first
  end

  def self.find_all_by_name(name)
    Merchant.where("name ILIKE ?", "%" + name + "%")
  end

  def self.top_merchants_by_revenue(quantity)
    Merchant
    .select('merchants.*, SUM(invoice_items.unit_price * invoice_items.quantity) as revenue')
    .joins(invoices: [:invoice_items, :transactions])
    .group(:id)
    .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
    .limit(quantity)
  end
end

# .where("transaction.result='success', invoices.status='shipped'")
