require 'rails_helper'

RSpec.describe 'Items API' do
  it 'sends a list of items' do
    create_list(:item, 2)

    get '/api/v1/items'

    expect(response).to be_successful
    expect(response.body).to include(Item.first.id.to_s)
  end

  it 'returns attributes for a single item' do
    create_list(:item, 2)

    get "/api/v1/items/#{Item.first.id}"

    expect(response.body).to include(Item.first.id.to_s)
    expect(response).to be_successful
  end

  it 'returns an empty array when there are no items' do

    get "/api/v1/items"

    expect(response).to be_successful
  end
end
