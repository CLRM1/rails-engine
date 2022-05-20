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
    search = params[:name]
    data_hash = { data: {}}
    if (params[:name] && params[:max_price]) || (params[:name] && params[:min_price])
      render json: data_hash, status: 400
    else
      if params[:min_price]
        if params[:min_price].to_f < 0
          data_hash = { data: {}, error: 'error'}
          render json: data_hash, status: 400
        # move to item model method pass[:min_price] param as argument
        else
          item = Item.where("unit_price >= #{params[:min_price]}").order("name").first
          if item == nil
            render json: data_hash, status: 200
          else
            render json: ItemsSerializer.format_item(item), status: :ok
          end
        end
      elsif params[:max_price]
        if params[:max_price].to_f < 0
          data_hash = { data: {}, error: 'error'}
          render json: data_hash, status: 400
        # move to item model method pass[:max_price] param as argument
        else
          item = Item.where("unit_price <= #{params[:max_price]}").order("name").first
          if item == nil
            render json: data_hash, status: 200
          else
            render json: ItemsSerializer.format_item(item), status: :ok
          end
        end
      else
          # move to item model method pass[:min_price] param as argument
        item = Item.where("name ILIKE ?", "%" + search + "%").first
        if Item.where("name ILIKE ?", "%" + search + "%").count == 0
          render json: data_hash, status: 404
        else
          render json: ItemsSerializer.format_item(item), status: :ok
        end
      end
    end
  end

  def find_all
    search = params[:name]
    data_hash = {data:[]}
    # move to item model method pass[:min_price] param as argument
    items = Item.where("name ILIKE ?", "%" + search + "%")

    if Item.where("name ILIKE ?", "%" + search + "%").count == 0
      render json: data_hash, status: 200
    else
      render json: ItemsSerializer.format_items(items), status: :ok
    end
  end

  private

    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end
end
