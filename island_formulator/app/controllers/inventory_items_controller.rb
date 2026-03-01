class InventoryItemsController < ApplicationController
  before_action :set_inventory_item, only: %i[ show edit update destroy ]

  # GET /inventory_items or /inventory_items.json
  def index
    @inventory_items = InventoryItem.all
  end

  # GET /inventory_items/1 or /inventory_items/1.json
  def show
  end

  # GET /inventory_items/new
  def new
    @inventory_item = InventoryItem.new
  end

  # GET /inventory_items/1/edit
  def edit
  end

  # POST /inventory_items or /inventory_items.json
  def create
    @inventory_item = InventoryItem.new(inventory_item_params)

    respond_to do |format|
      if @inventory_item.save
        format.html { redirect_to @inventory_item, notice: "Inventory item was successfully created." }
        format.json { render :show, status: :created, location: @inventory_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @inventory_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inventory_items/1 or /inventory_items/1.json
  def update
    respond_to do |format|
      if @inventory_item.update(inventory_item_params)
        format.html { redirect_to @inventory_item, notice: "Inventory item was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @inventory_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @inventory_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inventory_items/1 or /inventory_items/1.json
  def destroy
    @inventory_item.destroy!

    respond_to do |format|
      format.html { redirect_to inventory_items_path, notice: "Inventory item was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inventory_item
      @inventory_item = InventoryItem.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def inventory_item_params
      params.fetch(:inventory_item, {})
    end
end


class InventoryItemsController < ApplicationController
  before_action :require_authentication  # Add this line
  before_action :set_inventory_item, only: %i[ show edit update destroy ]

  def index
    # We use .includes(:ingredient) to avoid "N+1" queries.
    # This is a performance optimization that loads all ingredients in one go!
    @inventory_items = current_user.inventory_items.includes(:ingredient).order(purchase_date: :desc)
  end

  def show
  end

  def new
    @inventory_item = current_user.inventory_items.build
  end

  def edit
  end

  def create
    @inventory_item = current_user.inventory_items.build(inventory_item_params)

    if @inventory_item.save
      redirect_to inventory_items_path, notice: "Inventory item was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @inventory_item.update(inventory_item_params)
      redirect_to inventory_items_path, notice: "Inventory item was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @inventory_item.destroy
    redirect_to inventory_items_path, notice: "Inventory item was successfully removed."
  end

  private

  def set_inventory_item
    @inventory_item = current_user.inventory_items.find(params[:id])
  end

  def inventory_item_params
    params.require(:inventory_item).permit(:ingredient_id, :brand, :size, :location, :purchase_date, :notes, :photo)
  end
end