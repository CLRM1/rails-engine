class Api::V1::ItemsController < ApplicationController
  def index
    if params[:merchant_id]
      render json: ItemsSerializer.format_merchant_items(Merchant.find(params[:merchant_id])), status: :ok
    else
      render json: ItemsSerializer.format_items(Item.all), status: :ok
    end
  end

  def show
    render json: ItemsSerializer.format_item(Item.find(params[:id])), status: :ok
  end
end
