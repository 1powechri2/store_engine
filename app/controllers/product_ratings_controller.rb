# Allows setting ratings for product
class ProductRatingsController < ApplicationController

  before_filter :require_login
  before_filter :edit_with_time_limit, :only => [:edit, :update]

  def create
    p = params[:product_rating]
    product = Product.find(params[:product_id])
    product.product_ratings.new(:name => p[:name],
                                :body => p[:body],
                                :rating =>  p[:rating],
                                :user => current_user
                               )
    if product.save
      redirect_to product, :notice => "Comment successfully added"
    else
      flash[:error] = "There was an error with your comment"
      redirect_to product
    end
  end

  def edit
    @product = current_user.products.find(params[:product_id])
    @rating = current_user.product_ratings.find(params[:id])
  end

  def update
    @product = current_user.products.find(params[:product_id])
    @rating = current_user.product_ratings.find(params[:id])
    @rating.update_attributes(params[:product_rating])
    redirect_to product_path(@product) if @rating.save
  end

private

  def edit_with_time_limit
    @rating = current_user.product_ratings.find(params[:id])
    if @rating.created_at < Time.now - 15.minutes
      flash[:error] = "It has been too long to edit this review"
      redirect_to product_path(@rating.product)
    end
  end

end
