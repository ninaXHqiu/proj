class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def index
  @users=User.all
    if params[:search]
      @users = User.near(params[:search],1, :order => :distance)
    else
      @users = User.all
    end
    
    @users = User.paginate(page: params[:page], per_page: 10)
    
    # if params[:search]
    #   @user = User.search(params[:search]).order("created_at DESC")
    # else
    #   @users = User.all.order('created_at DESC')
    # end
  end



  

  def show
    @user = User.find(params[:id])
    @dogs = Dog.where(user_id: @user.id).order("created_at DESC")
    
    @reviews = Review.where(receiver_id: @user.id).order("created_at DESC").paginate(:page => params[:page], per_page: 2)
    @user_review = Review.where(receiver_id: @user.id)
    
    if @reviews.blank?
      @avg_review = 0
    else
      @avg_review = @reviews.average(:rating)#.round(2)
    end
  end
  
end
