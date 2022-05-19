class Api::V1::MerchantController < ApplicationController
  def index
    # require 'pry'; binding.pry
    # if params[:item_id] && !Item.find(params[:item_id]) == nil
      # require 'pry'; binding.pry
      render json: ItemMerchantSerializer.format_merchant(Item.find(params[:item_id]).merchant), status: :ok
    # end
  end
end
