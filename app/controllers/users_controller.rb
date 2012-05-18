class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :correct_user?
  before_filter :set_current_user
  before_filter :at_least_one_checked?, :only => [:edit_tags]
  
  def index
    @users = User.paginate(:page => params[:page])
  end

  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user
    else
      render :edit
    end
  end


  def show
    @post_lookup = PostLookup.new
  end


  def edit_tags
    Delayed::Job.enqueue EditJob.new(User.current)
  end 

end
