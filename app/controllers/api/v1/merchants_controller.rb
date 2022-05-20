class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantsSerializer.format_merchants(Merchant.all), status: :ok
  end

  def show
    render json: MerchantsSerializer.format_merchant(Merchant.find(params[:id])), status: :ok
  end

  def find
    # require 'pry'; binding.pry
    search = params[:name]
    data_hash = {
      data: {}
    }
    merchant = Merchant.where("name ILIKE ?", "%" + search + "%").first
    if Merchant.where("name ILIKE ?", "%" + search + "%").count == 0
      render json: data_hash, status: 404
    else
    render json: MerchantsSerializer.format_merchant(merchant), status: :ok
    end
  end
end
