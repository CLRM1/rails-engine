class MerchantsSerializer
  def self.format_merchants(merchants)
    if Merchant.all.count > 0
      {
        data: merchants.map do |merchant|
          {
            id: merchant.id.to_s,
            type: 'merchant',
            attributes: {
              name: merchant.name
            }
          }
        end
      }
    else
      []
    end
  end

  def self.format_merchant(merchant)
    {
      data:
      {
        id: merchant.id.to_s,
        type: 'merchant',
        attributes: {
          name: merchant.name
        }
      }
    }
  end

  def self.format_merchant_revenues(merchants)
    {
      data: merchants.map do |merchant|
      {
        id: merchant.id.to_s,
        type: 'merchant_name_revenue',
        attributes: {
          name: merchant.name,
          revenue: merchant.revenue
        }
      }
    end
    }
  end
end
