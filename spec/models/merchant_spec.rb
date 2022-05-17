require 'rails_helper'

RSpec.describe 'Merchant model' do
  it 'exists' do
    merchant = Merchant.create!(name: 'John')
    expect(merchant).to be_a(Merchant)
  end
end
