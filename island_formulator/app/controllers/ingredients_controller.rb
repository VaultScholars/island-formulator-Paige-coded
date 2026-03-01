class IngredientsController < ApplicationController
  before_action :require_authentication  
  before_action :set_ingredient, only: %i[ show edit update destroy ]

  # GET /ingredients or /ingredients.json
  def index
    @ingredients = current_user.ingredients
  end

  # GET /ingredients/1 or /ingredients/1.json
  def show
  end

  # GET /ingredients/new
  def new
    @ingredient = current_user.ingredients.build
  end

  

  # GET /ingredients/1/edit
  def edit
  end

  # POST /ingredients or /ingredients.json
  def create
    @ingredient = current_user.ingredients.build(ingredient_params)

    if @ingredient.save
      redirect_to @ingredient, notice: "Ingredient was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

    respond_to do |format|
      if @ingredient.save
        format.html { redirect_to @ingredient, notice: "Ingredient was successfully created." }
        format.json { render :show, status: :created, location: @ingredient }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ingredient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ingredients/1 or /ingredients/1.json
  def update
    respond_to do |format|
      if @ingredient.update(ingredient_params)
        format.html { redirect_to @ingredient, notice: "Ingredient was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @ingredient }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ingredient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ingredients/1 or /ingredients/1.json
  def destroy
    @ingredient.destroy!

    respond_to do |format|
      format.html { redirect_to ingredients_path, notice: "Ingredient was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ingredient
      @ingredient = Ingredient.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def ingredient_params
      params.expect(ingredient: [ :name, :category, :description, :notes ])
    end
    def ingredient_params
  # Add tag_ids: [] to the permit list
  # The [] means we are expecting an ARRAY of IDs (since you can check multiple boxes).
  # Note: tag_ids: [] must be the LAST parameter in the permit() call
  params.expect(ingredient: [ :name, :category, :description, :notes, tag_ids: [] ])
    end
    def ingredient_params
  params.require(:ingredient).permit(:name, :category, :description, :photo)
    end
end
 private

  def set_ingredient
    @ingredient = current_user.ingredients.find(params[:id])  # Was: Ingredient.find(params[:id])
  end

  def ingredient_params
    params.require(:ingredient).permit(:name, :category, :description, :notes, :photo, tag_ids: [])
  end
end