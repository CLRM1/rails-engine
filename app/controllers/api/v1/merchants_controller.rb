class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantsSerializer.format_merchants(Merchant.all), status: :ok
  end

  def show
    render json: MerchantsSerializer.format_merchant(Merchant.find(params[:id])), status: :ok
  end

  def find
    data_hash = {data:{}}
    merchant = Merchant.where("name ILIKE ?", "%" + params[:name] + "%").first

    if Merchant.where("name ILIKE ?", "%" + params[:name] + "%").count == 0
      render json: data_hash, status: 404
    else
      render json: MerchantsSerializer.format_merchant(merchant), status: :ok
    end
  end

  def find_all
    data_hash = {data:[]}
    merchants = Merchant.where("name ILIKE ?", "%" + params[:name] + "%")

    if Merchant.where("name ILIKE ?", "%" + params[:name] + "%").count == 0
      render json: data_hash, status: 200
    else
      render json: MerchantsSerializer.format_merchants(merchants), status: :ok
    end
  end
end
