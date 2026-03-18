class DashboardsController < ApplicationController
  def show
    @recent_recipes = current_user.recipes.order(created_at: :desc).limit(5)
    @recent_batches = current_user.batches.includes(:recipe).order(made_on: :desc).limit(5)
    
    @stats = {
      ingredients: current_user.ingredients.count,
      recipes: current_user.recipes.count,
      inventory: current_user.inventory_items.count,
      batches: current_user.batches.count
    }
     # Suggested Recipes feature
     @suggested_recipes = current_user.recipes.select do |recipe|
    recipe.ingredients.all? do |ingredient|
      inventory = current_user.inventory_items.find_by(ingredient_id: ingredient.id)
      inventory.present? && inventory.quantity >= ingredient.quantity
    end
  end
end
