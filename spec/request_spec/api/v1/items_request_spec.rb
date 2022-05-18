require 'rails_helper'

RSpec.describe 'Items API' do
  it 'sends a list of items' do
    merchant = Merchant.create!(name: 'Chris')
    create_list(:item, 2, merchant_id: merchant.id)

    get '/api/v1/items'

    expect(response).to be_successful
    expect(response.body).to include(Item.first.id.to_s)
  end

  it 'returns attributes for a single item' do
    merchant = Merchant.create!(name: 'Chris')
    create_list(:item, 2, merchant_id: merchant.id)

    get "/api/v1/items/#{Item.first.id}"

    expect(response.body).to include(Item.first.id.to_s)
    expect(response).to be_successful
  end

  it 'returns an empty array when there are no items' do

    get '/api/v1/items'

    expect(response).to be_successful
  end

  it 'creates a new item' do

    merchant = Merchant.create!(name: 'Chris')

    item_params = ({
        name: 'ball',
        description: 'You can throw it.',
        unit_price: 10,
        merchant_id: merchant.id
      })

    headers = {"CONTENT_TYPE" => "application/json"}

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

    new_item = Item.last
    expect(response).to be_successful
    expect(new_item.name).to eq('ball')
    expect(new_item.description).to eq('You can throw it.')
    expect(new_item.unit_price).to eq(10)
    expect(new_item.merchant_id).to eq(merchant.id)
  end
end
