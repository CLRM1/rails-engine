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
    if Merchant.where("name LIKE ?", "%" + search + "%")
      render json: Merchant.where("name ILIKE ?", "%" + search + "%")
    else
      render json: Merchant.where("name ILIKE ?", "%" + search + "%")
    end
  end
end
