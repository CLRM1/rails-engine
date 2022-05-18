class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemsSerializer.format_items(Item.all), status: :ok
  end

  def index_merchants
    render json: ItemsSerializer.format_merchant_items(Merchant.find(params[:merchant_id])), status: :ok
  end

  def show
    render json: ItemsSerializer.format_item(Item.find(params[:id])), status: :ok
  end

  def create
    render json: Item.create(item_params), status: :ok
  end

  def update
    # require 'pry'; binding.pry

    # if !Merchant.includes(Merchant.find(params[:merchant_id]))
      # render :json => { :errors => '404'}
    # else
      Item.update(params[:id], item_params)
      render json: ItemsSerializer.format_item(Item.find(params[:id])), status: :ok
    # end
  end

  private

    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end
end
