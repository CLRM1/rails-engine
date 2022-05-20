require 'rails_helper'

RSpec.describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 2)

    get '/api/v1/merchants'

    expect(response).to be_successful
    expect(response.body).to include(Merchant.first.id.to_s)
  end

  it 'returns attributes for a single merchant' do
    create_list(:merchant, 2)

    get "/api/v1/merchants/#{Merchant.first.id}"

    expect(response.body).to include(Merchant.first.id.to_s)
    expect(response).to be_successful
  end

  it 'returns an empty array when there are no merchants' do

    get "/api/v1/merchants"

    expect(response).to be_successful
  end

  it 'returns a merchants items' do
    merchant = Merchant.create!(name: 'Chris')
    merchant.items.create!(name: 'Ball', description: 'You can throw it.', unit_price: 5, merchant_id: merchant.id)
    get "/api/v1/merchants/#{Merchant.first.id}/items"
    expect(response.body).to include(Item.first.name)
  end

  it 'returns a merchant based on insensitive case search' do
    merchant = Merchant.create!(name: 'Tech Company')
    merchant.items.create!(name: 'Ball', description: 'You can throw it.', unit_price: 5, merchant_id: merchant.id)

    get "/api/v1/merchants/find?name=Company"

    expect(response.body).to include(merchant.name)

    get "/api/v1/merchants/find?name=company"

    expect(response.body).to include(merchant.name)

    get "/api/v1/merchants/find?name=comPany"

    expect(response.body).to include(merchant.name)
  end

  it 'returns all merchants based on insensitive case search' do
    merchant = Merchant.create!(name: 'Tech Company')
    merchant_2 = Merchant.create!(name: 'Steel Company')
    merchant_3 = Merchant.create!(name: 'Art Company')

    get "/api/v1/merchants/find_all?name=Company"

    expect(response.body).to include(merchant.name)
    expect(response.body).to include(merchant_2.name)
    expect(response.body).to include(merchant_3.name)
  end
end
