class GroupsController < ApplicationController
  load_and_authorize_resource
  skip_before_filter :require_activation
  before_filter :login_or_oauth_required
  
  def index
    # XXX can't define abilities w/ blocks (accessible_by) http://github.com/ryanb/cancan/wiki/Upgrading-to-1.4
    @groups = @groups.name_sorted_and_paginated(params[:page])

    respond_to do |format|
      format.html
    end
  end

  def show
    @forum = @group.forum
    @topics = Topic.find_recently_active(@forum, params[:page]) 
    respond_to do |format|
      format.html
      format.xml { render :xml => @group.to_xml(:methods => [:icon,:thumbnail], :only => [:id,:name,:description,:mode,:person_id,:created_at,:updated_at,:unit,:icon,:thumbnail]) }
    end
  end

  def new
    respond_to do |format|
      format.html
    end
  end

  def edit
  end

  def create
    @group.owner = current_person

    respond_to do |format|
      if @group.save
        flash[:notice] = 'Group was successfully created.'
        format.html { redirect_to(group_path(@group)) }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @group.update_attributes(params[:group])
        flash[:notice] = 'Group was successfully updated.'
        format.html { redirect_to(group_path(@group)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @group.destroy

    respond_to do |format|
      flash[:notice] = 'Group was successfully deleted.'
      format.html { redirect_to(groups_path) }
    end
  end
  
  def members
    @memberships = @group.memberships.paginate(:page => params[:page],
                                          :conditions => ['status = ?', 0],
                                          :include => :person,
                                          :per_page => RASTER_PER_PAGE)
    @pending = @group.pending_request.paginate(:page => params[:page],
                                          :per_page => RASTER_PER_PAGE)
    respond_to do |format|
      format.html
    end
  end
  
  def photos
    @group = Group.find(params[:id])
    @photos = @group.photos
    respond_to do |format|
      format.html
    end
  end
  
  def new_photo
    @photo = Photo.new

    respond_to do |format|
      format.html
    end
  end
  
  def save_photo
    group = Group.find(params[:id])
    if params[:photo].nil?
      # This is mainly to prevent exceptions on iPhones.
      flash[:error] = "Your browser doesn't appear to support file uploading"
      redirect_to(edit_group_path(group)) and return
    end
    if params[:commit] == "Cancel"
      flash[:notice] = "You have canceled the upload"
      redirect_to(edit_group_path(group)) and return
    end
    
    group_data = { :group => group,
                    :primary => group.photos.empty? }
    @photo = Photo.new(params[:photo].merge(group_data))
    
    respond_to do |format|
      if @photo.save
        flash[:success] = "Photo successfully uploaded"
        if group.owner == current_person
          format.html { redirect_to(edit_group_path(group)) }
        else
          format.html { redirect_to(group_path(group)) }
        end
      else
        format.html { render :action => "new_photo" }
      end
    end
  end
  
  def delete_photo
    @group = Group.find(params[:id])
    @photo = Photo.find(params[:photo_id])
    @photo.destroy
    flash[:success] = "Photo deleted for group '#{@group.name}'"
    respond_to do |format|
      format.html { redirect_to(edit_group_path(@group)) }
    end
  end
end
