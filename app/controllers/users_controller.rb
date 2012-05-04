class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :correct_user?
  #before_filter :at_least_one_checked?, :only => :edit_tags
  before_filter :tumblr_api, :only => [:show, :edit_tags]
  
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
    
  end


  def edit_tags
    @user = User.find(params[:id])
    @user.edit_tags
    #redirect_to root_path, notice: "Editing your tags. Please be patient."
    
  end #edit_tags

end
