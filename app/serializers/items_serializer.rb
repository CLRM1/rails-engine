class ItemsSerializer
  def self.format_items(items)
    if Item.all.count > 0
      {
        data: items.map do |item|
          {
            id: item.id.to_s,
            type: 'item',
            attributes: {
              name: item.name,
              description: item.description,
              unit_price: item.unit_price,
              merchant_id: item.merchant_id
            }
          }
      end
      }
    else
      []
    end
  end

  def self.format_item(item)
    {
      data:
        {
          id: item.id.to_s,
          type: 'item',
          attributes: {
            name: item.name,
            description: item.description,
            unit_price: item.unit_price,
            merchant_id: item.merchant_id
          }
        }
    }
  end
end
