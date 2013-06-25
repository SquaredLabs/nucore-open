class AccessoriesController < ApplicationController
  load_resource :order
  load_resource :order_detail, :through => :order

  before_filter :load_product

  def new
    accessorizer = Accessories::Accessorizer.new(@order_detail)
    @order_details = accessorizer.available_accessory_order_details
    render :layout => false if request.xhr?
  end

  def create
    accessorizer = Accessories::Accessorizer.new(@order_detail)
    @order_details = accessorizer.add_from_params(params[:accessories])
    @count = @order_details.count { |od| od.persisted? }

    if @order_details.none? { |od| od.errors.any? }
      flash[:notice] = "Reservation Ended, #{helpers.pluralize(@count, 'accessory')} added"
      if request.xhr?
        render :nothing => true, :status => 200
      else
        redirect_to reservations_path
      end
    else
      render :new
    end
  end

  private

  def load_product
    @product = @order_detail.product
  end

  def helpers
    ActionController::Base.helpers
  end
end
