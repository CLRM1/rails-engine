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
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'returns the items merchant' do
    merchant = Merchant.create!(name: 'Chris')
    item = merchant.items.create!(
      name: 'ball',
      description: 'You can throw it.',
      unit_price: 10,
      merchant_id: merchant.id)

    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful
    expect(response.body).to include(merchant.name)
  end

  it 'returns an item based on a case insensitve search' do
    merchant = Merchant.create!(name: 'Chris')
    item = merchant.items.create!(
      name: 'ball',
      description: 'You can throw it.',
      unit_price: 10,
      merchant_id: merchant.id)

    item_1 = merchant.items.create!(
      name: 'stall',
      description: 'You can put things in it.',
      unit_price: 100,
      merchant_id: merchant.id)

    item_2 = merchant.items.create!(
      name: 'the board game',
      description: 'You can play with it.',
      unit_price: 15,
      merchant_id: merchant.id)

    item_3 = merchant.items.create!(
      name: 'fan',
      description: 'It blows air.',
      unit_price: 8,
      merchant_id: merchant.id)

    get "/api/v1/items/find?name=all"

    expect(response.body).to include(item.name)
    expect(response.body).to_not include(item_2.name)
    expect(response.body).to_not include(item_3.name)

    get "/api/v1/items/find?name=All"

    expect(response.body).to include(item.name)
    expect(response.body).to_not include(item_2.name)
    expect(response.body).to_not include(item_3.name)

    get "/api/v1/items/find?name=gAmE"

    expect(response.body).to include(item_2.name)
    expect(response.body).to_not include(item.name)
    expect(response.body).to_not include(item_3.name)
  end

  it 'returns all matching items based on search' do
    merchant = Merchant.create!(name: 'Chris')
    item = merchant.items.create!(
      name: 'ball',
      description: 'You can throw it.',
      unit_price: 10,
      merchant_id: merchant.id)

    item_1 = merchant.items.create!(
      name: 'stall',
      description: 'You can put things in it.',
      unit_price: 100,
      merchant_id: merchant.id)

    item_2 = merchant.items.create!(
      name: 'the board game',
      description: 'You can play with it.',
      unit_price: 15,
      merchant_id: merchant.id)

    item_3 = merchant.items.create!(
      name: 'fan',
      description: 'It blows air.',
      unit_price: 8,
      merchant_id: merchant.id)

    get "/api/v1/items/find_all?name=all"

    expect(response.body).to include(item.name)
    expect(response.body).to include(item_1.name)
    expect(response.body).to_not include(item_2.name)
    expect(response.body).to_not include(item_3.name)
  end

  it 'returns an item with a specified minimum price' do
    merchant = Merchant.create!(name: 'Chris')
    item = merchant.items.create!(
      name: 'ball',
      description: 'You can throw it.',
      unit_price: 10,
      merchant_id: merchant.id)

    item_1 = merchant.items.create!(
      name: 'stall',
      description: 'You can put things in it.',
      unit_price: 150,
      merchant_id: merchant.id)

    item_2 = merchant.items.create!(
      name: 'the board game',
      description: 'You can play with it.',
      unit_price: 20,
      merchant_id: merchant.id)

    item_3 = merchant.items.create!(
      name: 'fan',
      description: 'It blows air.',
      unit_price: 9.99,
      merchant_id: merchant.id)

    get "/api/v1/items/find?min_price=10"

    expect(response.body).to include(item.name)
    expect(response.body).to_not include(item_1.name)
    expect(response.body).to_not include(item_2.name)
    expect(response.body).to_not include(item_3.name)
  end

  it 'returns an error when minimum price is bigger than any price' do
    merchant = Merchant.create!(name: 'Chris')
    item = merchant.items.create!(
      name: 'ball',
      description: 'You can throw it.',
      unit_price: 10,
      merchant_id: merchant.id)

    item_1 = merchant.items.create!(
      name: 'stall',
      description: 'You can put things in it.',
      unit_price: 150,
      merchant_id: merchant.id)

    item_2 = merchant.items.create!(
      name: 'the board game',
      description: 'You can play with it.',
      unit_price: 20,
      merchant_id: merchant.id)

    item_3 = merchant.items.create!(
      name: 'fan',
      description: 'It blows air.',
      unit_price: 9.99,
      merchant_id: merchant.id)

    get "/api/v1/items/find?min_price=160"

    expect(response.body).to_not include(item.name)
    expect(response.body).to_not include(item_1.name)
    expect(response.body).to_not include(item_2.name)
    expect(response.body).to_not include(item_3.name)
  end

  it 'returns an error when minimum price is less than zero' do
    merchant = Merchant.create!(name: 'Chris')
    item = merchant.items.create!(
      name: 'ball',
      description: 'You can throw it.',
      unit_price: 10,
      merchant_id: merchant.id)

    item_1 = merchant.items.create!(
      name: 'stall',
      description: 'You can put things in it.',
      unit_price: 150,
      merchant_id: merchant.id)

    item_2 = merchant.items.create!(
      name: 'the board game',
      description: 'You can play with it.',
      unit_price: 20,
      merchant_id: merchant.id)

    item_3 = merchant.items.create!(
      name: 'fan',
      description: 'It blows air.',
      unit_price: 9.99,
      merchant_id: merchant.id)

    get "/api/v1/items/find?min_price=-8"

    expect(response.body).to include('error')
    expect(response.body).to_not include(item.name)
    expect(response.body).to_not include(item_1.name)
    expect(response.body).to_not include(item_2.name)
    expect(response.body).to_not include(item_3.name)
  end

  it 'returns an item with a specified maximum price' do
    merchant = Merchant.create!(name: 'Chris')
    item = merchant.items.create!(
      name: 'ball',
      description: 'You can throw it.',
      unit_price: 10,
      merchant_id: merchant.id)

    item_1 = merchant.items.create!(
      name: 'stall',
      description: 'You can put things in it.',
      unit_price: 150,
      merchant_id: merchant.id)

    item_2 = merchant.items.create!(
      name: 'the board game',
      description: 'You can play with it.',
      unit_price: 20,
      merchant_id: merchant.id)

    item_3 = merchant.items.create!(
      name: 'fan',
      description: 'It blows air.',
      unit_price: 9.99,
      merchant_id: merchant.id)

    get "/api/v1/items/find?max_price=10"

    expect(response.body).to include(item.name)
  end

  it 'returns an item with a specified minimum and maximum price' do
    merchant = Merchant.create!(name: 'Chris')
    
    item = merchant.items.create!(
      name: 'ball',
      description: 'You can throw it.',
      unit_price: 10,
      merchant_id: merchant.id)

    item_1 = merchant.items.create!(
      name: 'stall',
      description: 'You can put things in it.',
      unit_price: 150,
      merchant_id: merchant.id)

    item_2 = merchant.items.create!(
      name: 'the board game',
      description: 'You can play with it.',
      unit_price: 20,
      merchant_id: merchant.id)

    item_3 = merchant.items.create!(
      name: 'fan',
      description: 'It blows air.',
      unit_price: 9.99,
      merchant_id: merchant.id)

    get "/api/v1/items/find?max_price=30&min_price=10"

    expect(response.body).to include(item.name)
    expect(response.body).to_not include(item_3.name)
  end
end
