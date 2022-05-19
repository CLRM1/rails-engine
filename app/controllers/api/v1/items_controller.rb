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
    item_id = Item.create(item_params).id
    if item_id != nil
      render json: ItemsSerializer.format_item(Item.find(item_id)), status: 201
    end
  end

  def update
    if params[:item][:merchant_id] == nil || Merchant.find(params[:item][:merchant_id]) == nil
      render json: 404
    else
      Item.update(params[:id], item_params)
      render json: ItemsSerializer.format_item(Item.find(params[:id])), status: :ok
    end
  end

  def destroy
    if Item.find(params[:id])
      if Item.find(params[:id]).invoices.count > 0
        Item.find(params[:id]).invoices.destroy(params[:id])
      end
    Item.destroy(params[:id])
    end
  end

  def find
    search = params[:name].downcase
    render json: Item.where("name LIKE ?", "%" + search + "%")
  end

  private

    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end
end
