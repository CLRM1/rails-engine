class Api::V1::MerchantController < ApplicationController
  def index
    render json: ItemMerchantSerializer.format_merchant(Item.find(params[:item_id]).merchant), status: :ok
  end
end
