class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoices, through: :merchant

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  validates_presence_of :merchant_id

  def self.find_by_min_price(min_price)
    Item.where("unit_price >= #{min_price}").order("name").first
  end

  def self.find_by_max_price(max_price)
    Item.where("unit_price <= #{max_price}").order("name").first
  end

  def self.find_by_name(name)
    Item.where("name ILIKE ?", "%" + name + "%").first
  end

  def self.find_all_by_name(name)
    Item.where("name ILIKE ?", "%" + name + "%")
  end
end
