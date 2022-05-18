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
    create_list(:merchant, 2)
    create_list(:item, 2)

    get "/api/v1/merchants/#{Merchant.first.id}/items"

    expect(response.body).to include(Item.first.name)
  end
end
