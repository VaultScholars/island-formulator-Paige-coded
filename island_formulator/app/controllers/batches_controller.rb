class BatchesController < ApplicationController
  before_action :require_authentication
  before_action :set_batch, only: %i[ show edit update destroy ]

  # GET /batches or /batches.json
  def index
    @batches = current_user.batches.includes(:recipe).order(made_on: :desc)
  end

  # GET /batches/1 or /batches/1.json
  def show
    @batch = current_user.batches.find(params[:id])
    # Build a new batch for the form
    @recipe = @batch.recipe
    @batch = current_user.batches.build(recipe: @recipe, made_on: Date.today)

  # Optionally, fetch recent batches
    @batches = @recipe.batches.order(made_on: :desc).limit(5)
  end
  

  def create
  @batch = current_user.batches.build(batch_params)

  @batch.recipe_id ||= params[:batch][:recipe_id] || params[:recipe_id]

  if @batch.save
    redirect_to batches_path, notice: "Batch was successfully logged."
  else
    render :new, status: :unprocessable_entity
  end
end

def new
  # Build a batch for the current user
  @batch = current_user.batches.build(made_on: Date.today)

  # Prefill recipe_id if passed
  if params[:recipe_id].present?
    @batch.recipe_id = params[:recipe_id]
  end
end

  # GET /batches/1/edit
  def edit
  end

  # POST /batches or /batches.json
  def create
    @batch = current_user.batches.build(batch_params)

  if @batch.save
      redirect_to batches_path, notice: "Batch was successfully logged."
  else 
         render :new, status: :unprocessable_entity
  end
end
   
  # PATCH/PUT /batches/1 or /batches/1.json
  def update
    respond_to do |format|
      if @batch.update(batch_params)
        format.html { redirect_to @batch, notice: "Batch was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @batch }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @batch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /batches/1 or /batches/1.json
  def destroy
    @batch.destroy!

    respond_to do |format|
      format.html { redirect_to batches_path, notice: "Batch was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_batch
      @batch = Batch.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def batch_params
     params.require(:batch).permit(:recipe_id, :made_on, :notes)
    end
  end