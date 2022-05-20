require 'rails_helper'

RSpec.describe Item,'Item model' do
  before(:each) do
    @merchant = Merchant.create!(name: 'John')
    @item = @merchant.items.create!(
      name: 'ball',
      description: 'You can throw it.',
      unit_price: 10,
      merchant_id: @merchant.id)
  end

  context 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :merchant_id }
  end

  context 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoices }
  end
end
