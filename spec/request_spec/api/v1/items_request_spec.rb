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

  it 'fails to create a new item when attributes are missing' do
    merchant = Merchant.create!(name: 'Chris')
    item_params = ({
        name: 'ball',
        description: 'You can throw it.',
        merchant_id: merchant.id
      })
    headers = {"CONTENT_TYPE" => "application/json"}

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

    expect(Item.count).to be(0)
  end

  it 'updates an item' do
    merchant = Merchant.create!(name: 'Chris')
    item = merchant.items.create!(
        name: 'ball',
        description: 'You can throw it.',
        unit_price: 10,
        merchant_id: merchant.id)

    item_params = ({
        name: 'frisbee',
        description: 'You can toss it.',
        unit_price: 10.55,
        merchant_id: merchant.id
      })
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({item: item_params})

    updated_item = Item.find(item.id)
    expect(response).to be_successful
    expect(updated_item.name).to_not eq('ball')
    expect(updated_item.name).to eq('frisbee')
  end

  it 'updates an item with partial information' do
    merchant = Merchant.create!(name: 'Chris')
    item = merchant.items.create!(
        name: 'ball',
        description: 'You can throw it.',
        unit_price: 10,
        merchant_id: merchant.id)

    item_params = ({
        name: 'frisbee',
        description: 'You can toss it.',
        merchant_id: merchant.id
      })
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({item: item_params})
    updated_item = Item.find(item.id)
    expect(response).to be_successful
    expect(updated_item.name).to_not eq('ball')
    expect(updated_item.name).to eq('frisbee')
    expect(updated_item.description).to eq('You can toss it.')
    expect(updated_item.unit_price).to eq(10)
  end

  it 'deletes an item' do
    merchant = Merchant.create!(name: 'Chris')
    item = merchant.items.create!(
      name: 'ball',
      description: 'You can throw it.',
      unit_price: 10,
      merchant_id: merchant.id)
    create_list(:item, 2, merchant_id: merchant.id)

    expect(Item.count).to eq(3)
    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(2)
    # expect(Item.find(item.id)).to rais_error(ActiveRecord::RecordNotFound)
  end
end
