require 'rails_helper'

RSpec.describe Merchant,'Merchant model' do
  before(:each) do
    @merchant = Merchant.create!(name: 'John')
  end

  context 'validations' do
    it { should validate_presence_of :name }
  end

  context 'relationships' do
    it { should have_many :items }
  end
end
