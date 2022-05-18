require 'rails_helper'

RSpec.describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 2)

    get '/api/v1/merchants'

    expect(response).to be_successful
  end

  it 'displays attributes for a single merchant' do
    create_list(:merchant, 2)

    get "/api/v1/merchants/#{Merchant.first.id}"

    expect(response).to be_successful
  end
end