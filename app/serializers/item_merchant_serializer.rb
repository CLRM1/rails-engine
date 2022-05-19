class ItemMerchantSerializer
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
end
