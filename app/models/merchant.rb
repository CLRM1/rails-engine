class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :items
  has_many :invoices

  def self.find_by_name(name)
    Merchant.where("name ILIKE ?", "%" + name + "%").first
  end

  def self.find_all_by_name(name)
    Merchant.where("name ILIKE ?", "%" + name + "%")
  end
end
